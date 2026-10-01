class CodexHub < Formula
  include Language::Python::Virtualenv

  desc "Native terminal workspace for Codex projects and persistent chats"
  homepage "https://github.com/mhadifilms/codex-hub"
  url "https://github.com/mhadifilms/codex-hub/releases/download/v0.1.0/codex-hub-0.1.0.tar.gz"
  sha256 "1214a14c09576ab966b87129b9cfe2dcf2ed56fba2036285f1fb6dfd6feffca0"
  license "MIT"

  depends_on "jpeg-turbo"
  depends_on "python@3.12"
  depends_on "tmux"
  depends_on "zlib"

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pillow" do
    url "https://files.pythonhosted.org/packages/1c/3d/bb7fca845737cf9d7dbde16ed1843984665ff2e0a518f5db43e77ec540b9/pillow-12.3.0.tar.gz"
    sha256 "3b8182a766685eaa002637e28b4ec8d6b18819a0c71f579bf0dbaa5830297cce"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/e9/67/cae617f1351490c25a4b8ac3b8b63a4dda609295d8222bad12242dfdc629/rich-14.3.4.tar.gz"
    sha256 "817e02727f2b25b40ef56f5aa2217f400c8489f79ca8f46ea2b70dd5e14558a9"
  end

  def install
    shared = libexec/"share/codex-hub"
    venv = virtualenv_create(shared/"venv", "python3.12")
    resources.each { |r| venv.pip_install r }
    shared.install Dir["lib/*.py"], "VERSION", "tmux.conf"
    (libexec/"bin").install Dir["bin/*"]
    %w[codex-hub codex-sub codex-hub-usage].each do |name|
      bin.write_exec_script libexec/"bin"/name
    end
  end

  def caveats
    codex_install = OS.mac? ? "brew install --cask codex" : "npm install --global @openai/codex"
    <<~EOS
      Install the official Codex CLI if needed:
        #{codex_install}
      Sign in and launch:
        codex login
        codex-hub
    EOS
  end

  test do
    ENV["CODEX_HUB_ROOT"] = (testpath/"settings").to_s
    assert_match "Codex Hub #{version}", shell_output("#{bin}/codex-hub --version")
    system bin/"codex-hub", "accounts", "add", "work", "--label", "Work"
    assert_match "Work", shell_output("#{bin}/codex-hub accounts list")
    assert_path_exists testpath/"settings/tmux.conf"
    system libexec/"share/codex-hub/venv/bin/python", "-c", "from PIL import Image; Image.new('RGB', (16, 16)).save('test.jpg')"
    assert_path_exists testpath/"test.jpg"
  end
end
