Releases
========

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

vNext
-----

v0.2.0 (2018-05-01)
-------------------

- Added: Version flag to print the version of the CLI
- Added: Test flag for a dry run which only prints the network interface table
- Improved: Released binaries are much smaller because they get shrinked with UPX ([issue #1](https://github.com/philippgille/serve/issues/1))
- Fixed: Network interface table looks bad on Windows ([issue #2](https://github.com/philippgille/serve/issues/2))
- Fixed: IPv4 address doesn't get printed for the main network interface on Windows ([issue #3](https://github.com/philippgille/serve/issues/3))

v0.1.0 (2018-05-01)
-------------------

- Added: Basic temporary static file server that prints the local interfaces and their addresses
