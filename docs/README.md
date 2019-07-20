`serve` Documentation
=====================

Contents
---------

- [Manual Installation](#manual-installation)
    - [Windows](#windows)
    - [macOS](#macos)
    - [Linux](#linux)

Manual Installation
-------------------

### Windows

Follow these steps manually, or jump below for the PowerShell commands:

1. Download the archive for Windows from the [releases](https://github.com/philippgille/serve/releases)
2. Extract the archive and make `serve` available as shell command in one of the following ways:
    - Put the binary into a directory that's in your `PATH`
    - Add the directory where you put the binary to the `PATH`
    - Create a function that calls the binary in your shell's profile
        - The PowerShell profile is located at `$profile`
            - Example: `C:\Users\John\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`
        - Example function: `function serve { $env:USERPROFILE\Downloads\serve_v0.3.2_Windows_x64\serve.exe $args }`
        - Don't forget to load your profile afterwards with `. $profile`

As PowerShell commands:

```powershell
# Create directory in the common ProgramData directory (used by many tools, such as Chocolatey)
New-Item "C:\ProgramData\serve" -Force
# Download the binary, first configure TLS 1.2 to be used instead of TLS 1.0
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$version = (Invoke-Webrequest https://raw.githubusercontent.com/philippgille/serve/master/VERSION).Content
Invoke-Webrequest https://github.com/philippgille/serve/releases/download/v${version}/serve_v${version}_Windows_x64.exe -OutFile "C:\ProgramData\serve\serve.exe"
# Create a function in your PowerShell profile
Add-Content $profile 'function serve { $env:USERPROFILE\ProgramData\serve\serve.exe $args }'
# Load the profile
. $profile
```

> Note: `serve` doesn't update itself yet, so you have to check for new versions manually.

### macOS

1. Download the archive for macOS from the [releases](https://github.com/philippgille/serve/releases)
2. Extract the archive and make `serve` executable via the terminal command `chmod 754 /path/to/serve`
3. Make `serve` available as shell command by one of the following ways:
    - Move it to a directory that's in your `PATH`
    - Add the directory where you put the binary to the `PATH`
    - Add a function to your shell's profile

> Note: `serve` doesn't update itself yet, so you have to check for new versions manually.

### Linux

There are many ways to manually install `serve` in Linux. Some of them are:

- Download the binary directly to a directory that's in your `PATH`
    ```bash
    # Download the binary, sudo for writing to `/usr/local/bin`
    VERSION=$(curl -L https://raw.githubusercontent.com/philippgille/serve/master/VERSION)
    sudo curl -L -o /usr/local/bin/serve https://github.com/philippgille/serve/releases/download/v${VERSION}/serve_v${VERSION}_Linux_x64
    # Make the file executable
    sudo chmod 754 /usr/local/bin/serve
    ```
- Put the binary somewhere in your `$HOME` directory and add that directory to your `PATH`
    ```bash
    # Create directory
    mkdir -p ~/Apps/CLI
    # Download the binary to your `Downloads` directory
    VERSION=$(curl -L https://raw.githubusercontent.com/philippgille/serve/master/VERSION)
    curl -L -o ~/Apps/CLI/serve https://github.com/philippgille/serve/releases/download/v${VERSION}/serve_v${VERSION}_Linux_x64
    # Make the file executable
    sudo chmod 754 ~/Apps/CLI/serve
    # Add the directory to your `PATH`
    echo 'export PATH=$PATH:~/Apps/CLI' >> ~/.bashrc
    # Load the profile
    source ~/.bashrc
    ```
- Put the binary somewhere in your `$HOME` directory and only create a symbolic link in `/usr/local/bin`
    ```bash
    # Download the binary to your `Downloads` directory
    VERSION=$(curl -L https://raw.githubusercontent.com/philippgille/serve/master/VERSION)
    curl -L -o ~/Downloads/serve https://github.com/philippgille/serve/releases/download/v${VERSION}/serve_v${VERSION}_Linux_x64
    # Make the file executable
    sudo chmod 754 ~/Downloads/serve
    # Create a symbolic link in your `/usr/local/bin` directory
    sudo ln -s ~/Downloads/serve /usr/local/bin/serve
    ```
- Put the binary somewhere in your `$HOME` directory and create a function in your shell's profile
    ```bash
    # Download the binary to your `Downloads` directory
    VERSION=$(curl -L https://raw.githubusercontent.com/philippgille/serve/master/VERSION)
    curl -L -o ~/Downloads/serve https://github.com/philippgille/serve/releases/download/v${VERSION}/serve_v${VERSION}_Linux_x64
    # Make the file executable
    sudo chmod 754 ~/Downloads/serve
    # Create a function in your shell's profile
    echo 'function serve() { $HOME/Downloads/serve $@; }' >> ~/.bashrc
    # Load the profile
    source ~/.bashrc
    ```

Alternatively, download the archive for Linux from the [releases](https://github.com/philippgille/serve/releases) and use your own favorite method to make `serve` available as shell command :)

> Note: `serve` doesn't update itself yet, so you have to check for new versions manually.
