class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.19.tar.gz"
  sha256 "afc0b0912e5fa977007cfd97805849a3a47564eaaaa1638948081665ad7224c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "7204ed756be7fa8c168aed4cd5bece96d60bffd9cd04f85867587f2d29e83c1e" => :catalina
    sha256 "3c519df1ceb1994f87dedf540b647c188d3031552b04048ba385cba264474100" => :mojave
    sha256 "bc552d3cd0331f264d0459d861a28493cac20f25e8de258151525d8a058cab68" => :high_sierra
    sha256 "e2e65f8c116d0fd12fdd70d43c98a09459383b3992dd694bb5dc7ab41d386f90" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    ln_s buildpath/"_dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
