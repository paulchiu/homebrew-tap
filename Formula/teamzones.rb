class Teamzones < Formula
  desc "Who's available and where it's busy, on one time axis. A Rust TUI."
  homepage "https://github.com/paulchiu/teamzones-tui"
  version "0.13.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paulchiu/teamzones-tui/releases/download/v0.13.0/teamzones-aarch64-apple-darwin.tar.xz"
      sha256 "7b4f6f0c5322025ab728d3770bf08b941b16f4bb2c43023a8d9f055b9c18e75d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paulchiu/teamzones-tui/releases/download/v0.13.0/teamzones-x86_64-apple-darwin.tar.xz"
      sha256 "4c7d5ec74f36de730d916166d9e7e41a22fa1cd66f49c2409db8e0d7ce7bf123"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/paulchiu/teamzones-tui/releases/download/v0.13.0/teamzones-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "9f065e9172fc5283bbb2c08f8854da9c14e3b3f6ace870495e5e64b2078f4e82"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "teamzones"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "teamzones"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "teamzones"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
