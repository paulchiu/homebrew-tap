class Repon < Formula
  desc "A terminal UI for the outer loop: seeing many git repos at once and acting on many in one gesture"
  homepage "https://github.com/paulchiu/repon"
  version "0.30.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paulchiu/repon/releases/download/v0.30.4/repon-aarch64-apple-darwin.tar.xz"
      sha256 "fa2ddf7f8c0fc62935e07908eadf847dacef29b207f5857c01b28e3163360bec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paulchiu/repon/releases/download/v0.30.4/repon-x86_64-apple-darwin.tar.xz"
      sha256 "b39839eee2a7685a5e739b5abf5940928385ee177e968ccc89d7bef409dff4d4"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/paulchiu/repon/releases/download/v0.30.4/repon-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "9651cf09d55ab9fbed75bcfc9222534e5d8c2a1147d9faeb7d66f7829b1d5b05"
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
