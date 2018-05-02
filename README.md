serve
=====

[![Build Status](https://travis-ci.org/philippgille/serve.svg?branch=master)](https://travis-ci.org/philippgille/serve/branches) [![Build status](https://ci.appveyor.com/api/projects/status/nt16vsv7j1yk9yo2/branch/master?svg=true)](https://ci.appveyor.com/project/philippgille/serve/branch/master) [![Go Report Card](https://goreportcard.com/badge/github.com/philippgille/serve)](https://goreportcard.com/report/github.com/philippgille/serve) [![GitHub Releases](https://img.shields.io/github/release/philippgille/serve.svg)](https://github.com/philippgille/serve/releases)

`serve` starts a simple temporary static file server in your current directory and prints your IP address to share with colleagues.

It's based on [this Gist](https://gist.github.com/paulmach/7271283/2a1116ca15e34ee23ac5a3a87e2a626451424993) by [Paul Mach](https://github.com/paulmach).

Contents
--------

- [Install](#install)
- [Use](#use)
    - [Example](#example)
- [Build](#build)

Install
-------

With Go installed:

`go get github.com/philippgille/serve`

Without Go installed:

1. Download the correct archive for your OS from [GitHub Releases](https://github.com/philippgille/serve/releases)
2. Extract the archive and make `serve` available as shell command in one of the following ways:
    - Put the binary into a directory that's on your `PATH`
        - For example on Linux in `$HOME/bin` (for your current user) or `/usr/local/bin` (for all users)
    - Add the directory where you put the binary to the `PATH`
    - Create a function that calls the binary in your shell's profile
        - Windows:
            - The PowerShell profile is located at `$profile`
                - Example: `C:\Users\John\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`
            - Example function: `function serve { $env:USERPROFILE\Downloads\serve_v0.2.0_Windows_x64\serve.exe $args }`
            - Don't forget to load your profile afterwards with `. $profile`
        - Linux:
            - You should use a profile that's loaded for login shells as well as interactive non-login shells. When using Bash, `~.bashrc` is typically loaded by `~.profile` or `~.bash_profile`, so `~.bashrc` is a good place.
            - Example function: `function serve() { $HOME/Downloads/serve_v0.2.0_Linux_x64/serve $@; }`
            - Don't forget to load your profile afterwards with `source ~/.bashrc`

Use
---

```bash
$ serve -h
Usage of serve:
  -d string
        The directory of static file to host (default ".")
  -p string
        Port to serve on (default "8100")
  -t    Test / dry run (just prints the interface table)
  -v    Print the version
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

> Note: The binaries in GitHub Releases are shrinked with additional Go linker flags and UPX

To also make `serve` available as command in other directories:

1. Add `$GOPATH/bin` to your `PATH` if you haven't done that already when installing Go
2. Execute: `go install`

There are also build scripts for Windows and Linux for creating release artifacts (shrinked binaries for Windows, macOS and Linux):

- Windows: `.\build.ps1`
- Linux: `./build.sh`
