serve
=====

[![Build Status](https://travis-ci.org/philippgille/serve.svg?branch=master)](https://travis-ci.org/philippgille/serve) [![Build status](https://ci.appveyor.com/api/projects/status/nt16vsv7j1yk9yo2?svg=true)](https://ci.appveyor.com/project/philippgille/serve) [![Go Report Card](https://goreportcard.com/badge/github.com/philippgille/serve)](https://goreportcard.com/report/github.com/philippgille/serve)

`serve` starts a simple temporary static file server in your current directory and prints your IP address to share with colleagues.

It's based on [this Gist](https://gist.github.com/paulmach/7271283/2a1116ca15e34ee23ac5a3a87e2a626451424993) by [Paul Mach](https://github.com/paulmach).

Install
-------

With Go installed:

`go get github.com/philippgille/serve`

Without Go installed:

1. Download the correct binary for your OS from [GitHub Releases](https://github.com/philippgille/serve/releases)
2. Rename the file to "serve" (on Linux/macOS) or "serve.exe" (on Windows)
2. Make it available as shell command with one of the following options:
    - Put the binary into a directory that's on your `PATH`
        - For example `$HOME/bin` or `/usr/local/bin` on Linux
    - Add the directory where you put the binary to the `PATH`
    - Create an alias for the binary in your shell's profile (no need to rename the binary in this case)
        > Note: Most Windows folks don't know this, but PowerShell has a profile, too:  
        > Just examine the environment variable `$profile` to see the file's path.  
        > Example: `C:\Users\John\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`

Use
---

```bash
$ serve -h
Usage of serve:
  -d string
    	the directory of static file to host (default ".")
  -p string
    	port to serve on (default "8100")
```

Hit `^C` to cancel.

### Example

```bash
~/path/to/servable/files$ serve

Serving "." on all network interfaces (0.0.0.0) on HTTP port: 8100

Local network interfaces and their IP address so you can pass one to your colleagues:

   Interface    |  IPv4 Address   | IPv6 Address   
----------------|-----------------|----------------
lo              | 127.0.0.1       | ::1
eth0            |                 | 
wlan0           | 192.168.178.123 | fe80::e7b:fdaf:ae5d:3cfa
virbr0          | 192.168.122.1   | 
br-8ef347e8a4e9 | 172.22.0.1      | fe80::42:c9ff:fed3:35a
docker_gwbridge | 172.21.0.1      | 
docker0         | 172.17.0.1      | fe80::42:c6cf:fe3d:a554
veth0d522f4     |                 | fe80::307a:7fcf:fe3d:cba4

You probably want to share:
http://192.168.178.123:8100
```

Build
-----

To build `serve` by yourself:

1. [Install Go](https://golang.org/doc/install)
2. `cd` into the root directory of this repository
3. Execute: `go build`

> Note: The binaries in GitHub Releases are shrinked with additional Go linker flags

To also make `serve` available as command in other directories:

1. Add `$GOPATH/bin` to your `PATH` if you haven't done that already when installing Go
2. Execute: `go install`

There are also build scripts for Windows and Linux for creating release artifacts (shrinked binaries for Windows, macOS and Linux):

- Windows: `.\build.ps1`
- Linux: `./build.sh`
