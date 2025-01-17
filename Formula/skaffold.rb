class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v1.2.0",
      :revision => "80f82f42fe271aea1058f4a37776d52ab5a7c441"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e09c836eaf50d27ed9118210b6d05007e16f21212518f0dfc9fabc76da38c81f" => :catalina
    sha256 "31babe4ec12ae83d21d6cb933bd7ef36912851cd220ceb7d25c94cf510c1f62d" => :mojave
    sha256 "e27916fc9c60b514f8efefa194998253955da864e9b974acf0737e92c7727ca5" => :high_sierra
    sha256 "e1081cc408d94c324bf1e03119aa7967b89ac050ced76c80a7b77f9b3d69ba65" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/GoogleContainerTools/skaffold"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      system "make"
      bin.install "out/skaffold"

      output = Utils.popen_read("#{bin}/skaffold completion bash")
      (bash_completion/"skaffold").write output

      output = Utils.popen_read("#{bin}/skaffold completion zsh")
      (zsh_completion/"_skaffold").write output

      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/skaffold version --output {{.GitTreeState}}")
    assert_match "clean", output
  end
end
