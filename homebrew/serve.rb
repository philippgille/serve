class Serve < Formula
    desc "`serve` starts a simple temporary static file server in your current directory and prints your IP address to share with colleagues"
    homepage "https://github.com/philippgille/serve"
    url "https://github.com/philippgille/serve/releases/download/v0.3.2/serve_v0.3.2_macOS_x64.zip"
    sha256 "E9C4910E82A3F407E0EAE19AABEB30ED8376F432B7811F9D2A2C2721054CF1D4"
    version "0.3.2"

    bottle :unneeded

    def install
        bin.install "serve"
    end

    test do
        system "serve", "-t"
    end
end
