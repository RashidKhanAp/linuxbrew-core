class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.5.5.tar.gz"
  sha256 "01dee8065b7441ec501d0fed9a5e32d1414faf8a10e0ce2846cd2e87ea6af834"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3bdd6448a7ac5757902b8f44d6a52e6a9621843d21aeca20fcd5c496a4491fb" => :catalina
    sha256 "8cb10c47de4d7897202935cf772c937426c1364866d42a21c8af7e9765769291" => :mojave
    sha256 "3dfd286d1730feae1cf0450c697ba3cb4f4694f3eb70d1f33e1b913219019229" => :high_sierra
    sha256 "6ef4e2d406c20c09b84a10cc8e8669093b7feb4a73bd386ef1456a684c472b86" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system "#{bin}/just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
