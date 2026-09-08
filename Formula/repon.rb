class Repon < Formula
  desc "A terminal UI for the outer loop: seeing many git repos at once and acting on many in one gesture"
  homepage "https://github.com/paulchiu/repon"
  version "0.32.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paulchiu/repon/releases/download/v0.32.0/repon-aarch64-apple-darwin.tar.xz"
      sha256 "3387c662cbd3aa3a7c31d87c6fe70eb7e21985ba6c1b4fb49796a89438dfd788"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paulchiu/repon/releases/download/v0.32.0/repon-x86_64-apple-darwin.tar.xz"
      sha256 "9d0e5ba203cd1a324c333749e09f07c2c97c17ed162f9c3d24564aadb1f97656"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/paulchiu/repon/releases/download/v0.32.0/repon-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f7db5811b86d1ab7868dee208e1d0fd48d1e018626f109c63c45e72323a2a739"
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
