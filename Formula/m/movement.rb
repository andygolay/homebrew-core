class Movement < Formula
    desc "The first MoveVM Zk Layer 2 on Ethereum"
    homepage "https://movementlabs.xyz"
    url "<link-to-tarball>"
    sha256 "<checksum>"
    license "Apache-2.0"
    head "https://github.com/movementlabsxyz/aptos-core.git", branch: "main"
  
    livecheck do
      url :stable
      regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
    end
  
    bottle do
      sha256 cellar: :any_skip_relocation, arm64_sonoma:   "<checksum>"
      sha256 cellar: :any_skip_relocation, arm64_ventura:  "<checksum>"
      sha256 cellar: :any_skip_relocation, arm64_monterey: "<checksum>"
      sha256 cellar: :any_skip_relocation, sonoma:         "<checksum>"
      sha256 cellar: :any_skip_relocation, ventura:        "<checksum>"
      sha256 cellar: :any_skip_relocation, monterey:       "<checksum>"
      sha256 cellar: :any_skip_relocation, x86_64_linux:   "<checksum>"
    end
  
    depends_on "cmake" => :build
    depends_on "rust" => :build
    depends_on "rustfmt" => :build
    uses_from_macos "llvm" => :build
  
    on_linux do
      depends_on "pkg-config" => :build
      depends_on "zip" => :build
      depends_on "openssl@3"
      depends_on "systemd"
    end
  
    def install
      # FIXME: Figure out why cargo doesn't respect .cargo/config.toml's rustflags
      ENV["RUSTFLAGS"] = "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
      system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
    end
  
    test do
      assert_match(/output.pub/i, shell_output("#{bin}/movement key generate --output-file output"))
    end
  end
