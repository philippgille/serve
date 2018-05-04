class Serve < Formula
    desc "`serve` starts a simple temporary static file server in your current directory and prints your IP address to share with colleagues"
    homepage "https://github.com/philippgille/serve"
    url "https://github.com/philippgille/serve/releases/download/v0.2.0/serve_v0.2.0_macOS_x64.zip"
    version "0.2.0"

    bottle :unneeded

    def install
        bin.install "serve"
    end

    test do
        system "serve", "-t"
    end
end
