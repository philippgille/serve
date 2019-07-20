Before filing a bug or feature request, please check if a related issue already exists [here](https://github.com/philippgille/serve/issues).

If this is a feature request, describe the feature and add some info and links about how it could be implemented.

If this is a bug report, describe the expected behavior, the actual behavior and maybe your idea how to fix it.

Feature request
---------------

Example issue title: *Add automatic redirect from HTTP to HTTPS*

### Feature description

Example:
> Currently browsing to a `serve` server via HTTP when the server runs via HTTPS leads to an error. An automatic redirect would be nice though.

### Info

Example:
> For info about how to do that in Go see this StackOverflow answer: [https://stackoverflow.com/questions/37536006/how-do-i-rewrite-redirect-from-http-to-https-in-go](https://stackoverflow.com/questions/37536006/how-do-i-rewrite-redirect-from-http-to-https-in-go)

Bug
---

Example issue title: *Hidden files aren't served*

### Bug description

Example:
> Hidden files aren't served.


### Reproduction

Example:
> 1. Run `touch .example-hidden`
> 1. Run `snap install serve`
> 2. Run `serve`
> 3. => `http://localhost:8080` doesn't show the hidden file

### Info

Example:
> - Version: 0.3.2
> - Operating system: Ubuntu 16.04

### Possible solution

Example:
> Add additional optional permissions to the snap.
