class Serve < Formula
    desc "`serve` starts a simple temporary static file server in your current directory and prints your IP address to share with colleagues"
    homepage "https://github.com/philippgille/serve"
    url "https://github.com/philippgille/serve/releases/download/v0.3.0/serve_v0.3.0_macOS_x64.zip"
    sha256 "4DA48BD9B8DDC6CE30189B8E06D968954C56F3FE31BFCABB12DA265D1EF07C24"
    version "0.3.0"

    bottle :unneeded

    def install
        bin.install "serve"
    end

    test do
        system "serve", "-t"
    end
end
