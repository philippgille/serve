class Serve < Formula
    desc "`serve` starts a simple temporary static file server in your current directory and prints your IP address to share with colleagues"
    homepage "https://github.com/philippgille/serve"
    url "https://github.com/philippgille/serve/releases/download/v0.2.1/serve_v0.2.1_macOS_x64.zip"
    sha256 "5C4FEDEA1D6DB0F59DFFFA60986B3E12B4DDD64CDDF9394E15CA94F5635B9FE8"
    version "0.2.1"

    bottle :unneeded

    def install
        bin.install "serve"
    end

    test do
        system "serve", "-t"
    end
end
