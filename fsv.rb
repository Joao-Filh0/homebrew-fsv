class Fsv < Formula
  include Language::Python::Virtualenv

  url "https://github.com/Joao-Filh0/fsv/archive/refs/tags/0.0.5.tar.gz"
  sha256 "fd8ce859f78eaf22ae1c63e4503c526ac729fbcd08b318d2d5254e26110080e5"
  version "1.0.5"
  head "https://github.com/Joao-Filh0/fsv.git", branch: "main"

  depends_on "python@3.10"

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install_and_link buildpath

    (buildpath/"fsv").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/bin/python" "#{libexec}/../main.py" "$@"
    EOS

    chmod 0755, buildpath/"fsv"
    bin.install buildpath/"fsv"
    libexec.install "main.py"
  end

  test do
    system "#{bin}/fsv", "-pg"
  end

  def caveats
    <<~EOS
      You should add the following to your shell configuration file:
        export FSV_HOME="#{libexec}"
    EOS
  end
end
