class ZingArt < Formula
  desc " A TUI for physical string art placement. It takes a sequence, you pull the thread. ZING: Zing Is Not Generating."
  homepage "https://github.com/000volk000/zing"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/000volk000/zing/releases/download/v1.1.0/zing-art-aarch64-apple-darwin.tar.xz"
      sha256 "6e18851351c9b73e0ceb0170155c37df89ec9c1242f29441332ffbca46c7d3c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/000volk000/zing/releases/download/v1.1.0/zing-art-x86_64-apple-darwin.tar.xz"
      sha256 "70c8d2dfc6b9223cbec1a04a3d67761e3b31a5a3626e2456b422f0191f5b2f4c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/000volk000/zing/releases/download/v1.1.0/zing-art-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6c6cc595cbcf755914066920835d55af684266ac01f268a078f0e8de724c1b71"
    end
    if Hardware::CPU.intel?
      url "https://github.com/000volk000/zing/releases/download/v1.1.0/zing-art-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "66ae94bc1650fdc00b3d90d71b7d79722c74f0713c848f5a8d63009567820e24"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "zing" if OS.mac? && Hardware::CPU.arm?
    bin.install "zing" if OS.mac? && Hardware::CPU.intel?
    bin.install "zing" if OS.linux? && Hardware::CPU.arm?
    bin.install "zing" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
