class Serve < Formula
    desc "`serve` starts a simple temporary static file server in your current directory and prints your IP address to share with colleagues"
    homepage "https://github.com/philippgille/serve"
    url "https://github.com/philippgille/serve/releases/download/v0.3.1/serve_v0.3.1_macOS_x64.zip"
    sha256 "0F1D2282EE88C081C8AF4C397182B5859B8FBF32100B33EC835F454275371002"
    version "0.3.1"

    bottle :unneeded

    def install
        bin.install "serve"
    end

    test do
        system "serve", "-t"
    end
end
