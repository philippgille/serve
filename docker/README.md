`serve` Docker Image
====================

`serve` starts a simple temporary static file server in your current directory and prints your IP address to share with colleagues.

Supported tags and respective `Dockerfile` links
------------------------------------------------

- [`latest` (docker/Dockerfile)](https://github.com/philippgille/serve/blob/master/docker/Dockerfile)

Usage
-----

### Linux

`docker run -v $(pwd):/srv --network host philippgille/serve`

> Note: The `--network host` flag is required so that `serve` can determine the proper URL under which other machines in your local network can reach you. If you use `-p 8080:8080` instead, `serve` will work, but the printed table of local network interfaces and their IP addresses will be useless.

### Windows and macOS

`docker run -v $(pwd):/srv -p 8080:8080 philippgille/serve`

> Note: When using Windows or macOS, Docker containers run in a VM, so `serve` won't be able to print the correct local network interfaces of your host and their IP addresses no matter if you use `--network host` or not. Using that flag might even lead to Docker not being able to properly forward the network traffic to the container.
> 
> This also means that when using the `-s` flag, the generated TLS certificate doesn't contain the correct DNS names and IP addresses *by default*. In most cases this doesn't matter, because most browsers don't to hostname validation anyway in case they encounter a self signed certificate whose CA is not installed in the trusted root store of the client. But you can easily change this by using the `--hostname` flag when running the container.  
> For example, let's say your machine's local network IP is `192.168.178.123`. Then you can use `serve` including its HTTPS feature via Docker with the following command: `docker run -v $(pwd):/srv -p 8443:8443 --hostname 192.168.178.123 philippgille/serve -s`

More information
----------------

To learn more about `serve`, visit [https://github.com/philippgille/serve](https://github.com/philippgille/serve)
