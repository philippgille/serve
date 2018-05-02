`serve` Documentation
=====================

Contents
---------

- [Manual Installation](#manual-installation)

Manual Installation
-------------------

1. Download the correct archive for your OS from the [releases](https://github.com/philippgille/serve/releases)
2. Extract the archive and make `serve` available as shell command in one of the following ways:
    - Put the binary into a directory that's in your `PATH`
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

`serve` doesn't update itself yet, so you have to check for new versions manually as well.
