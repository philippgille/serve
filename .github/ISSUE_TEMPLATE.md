Before filing a bug or feature request, please check if a related issue already exists [here](https://github.com/philippgille/serve/issues).

If this is a feature request, describe the feature and add some info and links about how it could be implemented.

If this is a bug report, describe the expected behavior, the actual behavior and maybe your idea how to fix it.

Feature request
---------------

Example issue title: *Automatically add AppImage to GitHub Releases*

### Feature description

Example:
> Currently only the FDD and SCD are deployed to GitHub Releases, but the AppImage should be deployed as well.

### Info

Example:
> For info about how to do that in Travis CI see this documentation: [Travis CI docs - GitHub Releases Uploading](https://docs.travis-ci.com/user/deployment/releases/)

Bug
---

Example issue title: *Installing Chocolatey package via OneGet doesn't lead to the app being available on the PATH*

### Bug description

Example:
> When installing serve via OneGet from the MyGet feed the executable should be available on the PATH, but isn't.


### Reproduction

Example:
> 1. Run `install-Package my-app.portable -Source https://www.myget.org/F/my-feed -provider chocolatey`
> 2. Try to run `my-app`
>     - fails because it's not found on the PATH

### Info

Example:
> - Version: 0.1.0
> - Operating system: Windows 10 Pro Fall Creators Update

### Possible solution

Example:
> Probably blocked by https://github.com/chocolatey/chocolatey-oneget/issues/2.
