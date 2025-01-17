class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v1.0.2",
      :revision => "26a1365ddb58ec065101d2042c66da04e17bcfca"

  bottle do
    cellar :any_skip_relocation
    sha256 "d921148be1b3a2b16c33564c19122e7aa1ffb0f7c1fc0428ea79878d9065f6c3" => :catalina
    sha256 "a86478d4fd5a804d52418f8421b0734466a52aef530fc7a63478c4b70851b930" => :mojave
    sha256 "c36bda489d3e81e1e30815a237fe0be2cd88e9466553a3b8128befe53c2e5db2" => :high_sierra
    sha256 "877f6db1cf8c10eb36148b30ba5f1dc9377c0ad8f0f8f3c519b5697190c2de27" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rancher/rke").install buildpath.children

    cd "src/github.com/rancher/rke" do
      system "go", "build", "-ldflags",
             "-w -X main.VERSION=v#{version}",
             "-o", bin/"rke"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end
