`serve` Docker Image
====================

`serve` starts a simple temporary static file server in your current directory and prints your IP address to share with colleagues.

Supported Linux amd64 tags and respective `Dockerfile` links
------------------------------------------------

- [`latest` (docker/Dockerfile)](https://github.com/philippgille/serve/blob/master/docker/Dockerfile)

Usage
-----

`docker run -v ${PWD}:/share --network "host" philippgille/serve`

Detailed information
--------------------

To learn more about `serve`, visit [https://github.com/philippgille/serve](https://github.com/philippgille/serve)
