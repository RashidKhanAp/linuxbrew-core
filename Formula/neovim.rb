class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  url "https://github.com/neovim/neovim/archive/v0.4.2.tar.gz"
  sha256 "9f874d3d2a74f33b931db62adebe28f8d2ec116270d1e13998b58a73348b6e56"
  head "https://github.com/neovim/neovim.git"

  bottle do
    sha256 "5436532a1574329e386cf29df04e7d528730a7bd95c073b6ea76a37499ececc0" => :mojave
    sha256 "7d839a0c108ea2a95b7a61bde2fb08f667938bcad2e4a5d908d51a35d899c85c" => :high_sierra
    sha256 "73bc96be3bccacb2c6c02e4c3aaf06ad0dc4f3b34569a46adda8ec7b41db2f52" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libtermkey"
  depends_on "libuv"
  depends_on "libvterm"
  depends_on "luajit"
  depends_on "msgpack"
  depends_on "unibilium"
  unless OS.mac?
    depends_on "python@2"
    depends_on "unzip" => :build
    depends_on "gperf"
  end

  resource "mpack" do
    url "https://github.com/libmpack/libmpack-lua/releases/download/1.0.7/libmpack-lua-1.0.7.tar.gz"
    sha256 "68565484a3441d316bd51bed1cacd542b7f84b1ecfd37a8bd18dd0f1a20887e8"
  end

  resource "lpeg" do
    url "https://luarocks.org/manifests/gvvaughan/lpeg-1.0.2-1.src.rock"
    sha256 "e0d0d687897f06588558168eeb1902ac41a11edd1b58f1aa61b99d0ea0abbfbc"
  end

  resource "inspect" do
    url "https://luarocks.org/manifests/kikito/inspect-3.1.1-0.src.rock"
    sha256 "ea1f347663cebb523e88622b1d6fe38126c79436da4dbf442674208aa14a8f4c"
  end

  resource "lua-compat-5.3" do
    url "https://github.com/keplerproject/lua-compat-5.3/archive/v0.7.tar.gz"
    sha256 "bec3a23114a3d9b3218038309657f0f506ad10dfbc03bb54e91da7e5ffdba0a2"
  end

  resource "luv" do
    url "https://github.com/luvit/luv/releases/download/1.30.0-0/luv-1.30.0-0.tar.gz"
    sha256 "5cc75a012bfa9a5a1543d0167952676474f31c2d7fd8d450b56d8929dbebb5ef"
  end

  def install
    resources.each do |r|
      r.stage(buildpath/"deps-build/build/src/#{r.name}")
    end

    ENV.prepend_path "LUA_PATH", "#{buildpath}/deps-build/share/lua/5.1/?.lua"
    ENV.prepend_path "LUA_CPATH", "#{buildpath}/deps-build/lib/lua/5.1/?.so"
    lua_path = "--lua-dir=#{Formula["luajit"].opt_prefix}"

    cd "deps-build" do
      %w[
        mpack/mpack-1.0.7-0.rockspec
        lpeg/lpeg-1.0.2-1.src.rock
        inspect/inspect-3.1.1-0.src.rock
      ].each do |rock|
        dir, rock = rock.split("/")
        cd "build/src/#{dir}" do
          output = Utils.popen_read("luarocks", "unpack", lua_path, rock, "--tree=#{buildpath}/deps-build")
          unpack_dir = output.split("\n")[-2]
          cd unpack_dir do
            system "luarocks", "make", lua_path, "--tree=#{buildpath}/deps-build"
          end
        end
      end

      cd "build/src/luv" do
        cmake_args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] }
        cmake_args += %W[
          -DCMAKE_INSTALL_PREFIX=#{buildpath}/deps-build
          -DLUA_BUILD_TYPE=System
          -DWITH_SHARED_LIBUV=ON
          -DBUILD_SHARED_LIBS=OFF
          -DBUILD_MODULE=OFF
          -DLUA_COMPAT53_DIR=#{buildpath}/deps-build/build/src/lua-compat-5.3
        ]
        system "cmake", ".", *cmake_args
        system "make", "install"
      end
    end

    mkdir "build" do
      cmake_args = std_cmake_args
      cmake_args += %W[
        -DLIBLUV_INCLUDE_DIR=#{buildpath}/deps-build/include
        -DLIBLUV_LIBRARY=#{buildpath}/deps-build/lib/libluv.a
      ]
      system "cmake", "..", *cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.txt").write("Hello World from Vim!!")
    system bin/"nvim", "--headless", "-i", "NONE", "-u", "NONE",
                       "+s/Vim/Neovim/g", "+wq", "test.txt"
    assert_equal "Hello World from Neovim!!", (testpath/"test.txt").read.chomp
  end
end
