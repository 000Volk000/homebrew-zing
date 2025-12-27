class ZingArt < Formula
  desc " A TUI for physical string art placement. It takes a sequence, you pull the thread. ZING: Zing Is Not Generating."
  homepage "https://github.com/000volk000/zing"
  version "1.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/000volk000/zing/releases/download/v1.0.1/zing-art-aarch64-apple-darwin.tar.xz"
      sha256 "873648b51665b0018b0216413dd147dd3a32d4018a079993810e3da1e6227233"
    end
    if Hardware::CPU.intel?
      url "https://github.com/000volk000/zing/releases/download/v1.0.1/zing-art-x86_64-apple-darwin.tar.xz"
      sha256 "9c2593f35613d200d6381e16dfc042beb62b6dc4bc338886c9bfea81e97cf7d1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/000volk000/zing/releases/download/v1.0.1/zing-art-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d3de628d3f62f4a35b5fe2d740bdabd366c2f01943a1854c47622e1a11cf1186"
    end
    if Hardware::CPU.intel?
      url "https://github.com/000volk000/zing/releases/download/v1.0.1/zing-art-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e3f9a011c5e66b9462bae3ae70135cf8ee11125fa15824a8d5d7feac38f2d858"
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
    bin.install "zing-art" if OS.mac? && Hardware::CPU.arm?
    bin.install "zing-art" if OS.mac? && Hardware::CPU.intel?
    bin.install "zing-art" if OS.linux? && Hardware::CPU.arm?
    bin.install "zing-art" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
