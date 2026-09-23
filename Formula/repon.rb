class Repon < Formula
  desc "A terminal UI for the outer loop: seeing many git repos at once and acting on many in one gesture"
  homepage "https://github.com/paulchiu/repon"
  version "0.32.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paulchiu/repon/releases/download/v0.32.2/repon-aarch64-apple-darwin.tar.xz"
      sha256 "f8361040378f0e815ee72480b36180d664cda509c1411684427c820409aa49b5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paulchiu/repon/releases/download/v0.32.2/repon-x86_64-apple-darwin.tar.xz"
      sha256 "37193492293608344cefd75f8383d0ff1148191fb3e0a954ca75b0901a5be5c0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/paulchiu/repon/releases/download/v0.32.2/repon-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "dfd0a72d3b376a6a280bc361299d5f5bba5db0c5ebe5ce5827c2251fd740443f"
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
      bin.install "repon"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "repon"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "repon"
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
