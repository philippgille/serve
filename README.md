serve
=====

`serve` starts a simple temporary static file server in your current directory and prints your IP address to share with colleagues

Install
-------

With Go installed:

`go get github.com/philippgille/serve`

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

To also make `serve` available as command in other directories:

1. Add `$GOPATH/bin` to your `PATH` if you haven't done that already when installing Go
2. Execute: `go install`
