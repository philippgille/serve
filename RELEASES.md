Releases
========

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

vNext
-----

v0.3.2 (2019-07-20)
-------------------

> Note: Windows and Linux users who have `serve` v0.3.0 don't need to update to this version, because it only fixes a bug in v0.3.1 and v0.3.1 only contained a bugfix for macOS.

- Fixed: serve v0.3.1 reports version v0.3.0 when using `serve -v`

v0.3.1 (2019-07-20)
-------------------

> Note: This release only contains a bugfix for macOS. There's no need to update from v0.3.0 to this version on Windows or Linux.

- Fixed: `serve` crashes at start on macOS due to a bug in UPX, which is used to compress the executable file ([issue #27](https://github.com/philippgille/serve/issues/27))
  - See [https://github.com/upx/upx/issues/222](https://github.com/upx/upx/issues/222)
  - Only macOS is affected!

v0.3.0 (2019-05-04)
-------------------

- Added: Optional generation and use of a self signed certificate to serve files via HTTPS instead of HTTP ([issue #9](https://github.com/philippgille/serve/issues/9))
- Added: Optional basic authentication ([issue #10](https://github.com/philippgille/serve/issues/10))
- Added: Option to bind to a specific network interface ([issue #19](https://github.com/philippgille/serve/issues/19))
- Added: Exit with an error when using the `-d` flag and the argument is not a directory, the directory doesn't exist or the directory is not readable
- Added: Handling of the directory as positional argument. We keep this undocumented for now to not promote its use, but it was a common source of problems (where a directory was passed as positional argument and then "." was served), which are now mitigated.
- Improved: Updated building the snap with snapcraft 3.x instead of its 2.4x legacy mode
- Fixed: `serve -h` lead to exit code 2 instead of 0
- Fixed: Wrong documentation URL in the Chocolatey Nuspec file ([issue #18](https://github.com/philippgille/serve/issues/18))

### Breaking changes:

- Changed default port from 8100 to 8080, which is an official alternative to port 80 for HTTP
- Docker:
  - Changed default serving directory within the container from `/share` to `/srv`, which is a common directory for serving files
  - Moved `-d` flag from `CMD` to `ENTRYPOINT`, leading to fewer problems when using the Docker container with additional flags

v0.2.1 (2018-05-13)
-------------------

- Improved: Increased interface table width to 80 for long interface names
- Fixed: No suggested URL in several cases ([issue #7](https://github.com/philippgille/serve/issues/7))
- Fixed: Snap package doesn't work ([issue #14](https://github.com/philippgille/serve/issues/14))

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
