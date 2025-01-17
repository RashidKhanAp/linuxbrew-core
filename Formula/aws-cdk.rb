require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.21.1.tgz"
  sha256 "97ca367e809df5d113ed1be1b22ad3bd79849c1e09725377357c22f182dd1f0f"

  bottle do
    cellar :any_skip_relocation
    sha256 "23e0713ef82d518c7c8f7743a2561425bb0c1813a45838a0cf1305d19dbf3114" => :catalina
    sha256 "ab9fcb3e6194710c7cd846233082345b2c70949bb2cfb3c491411742ec3d756e" => :mojave
    sha256 "fd8c2243c16d4d700d98dc8316d7c8ee8a31f041413ac9163d3e12406f7eb237" => :high_sierra
    sha256 "7818425cf76c8a777f6d9b8d549f609d847e9b48099a62d89934f15a9418f900" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    mkdir "testapp"
    cd testpath/"testapp"
    shell_output("#{bin}/cdk init app --language=javascript")
    list = shell_output("#{bin}/cdk list")
    cdkversion = shell_output("#{bin}/cdk --version")
    assert_match "TestappStack", list
    assert_match version.to_s, cdkversion
  end
end
