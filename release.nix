with import <nixpkgs> {};

let
  installUsage = "You must first run install-tresorit-impure before using this command.";
  pure = import ./default.nix {};
  run-tresorit-install-script = writeShellScriptBin "install-tresorit-impure" ''
    mkdir -p $HOME/.local/share/tresorit
    cp -rf ${pure}/bin/* $HOME/.local/share/tresorit/
    chmod +w $HOME/.local/share/tresorit/tresorit.desktop
    cat >> $HOME/.local/share/tresorit/tresorit.desktop << EOF
    Exec=$HOME/.local/share/tresorit/tresorit %u
    MimeType=x-scheme-handler/tresorit
    Icon=$HOME/.local/share/tresorit/tresorit.png
    EOF
    ln -s $HOME/.local/share/tresorit/tresorit.desktop $HOME/.local/share/applications/tresorit.desktop
  '';
  run-tresorit-script = writeShellScriptBin "tresorit-impure" ''
    BIN=$HOME/.local/share/tresorit/tresorit
    if [ -f $BIN ]; then
      $BIN "$@"
    else
      echo ${installUsage}
    fi
  '';
  run-tresorit-cli-script = writeShellScriptBin "tresorit-cli-impure" ''
    BIN=$HOME/.local/share/tresorit/tresorit-cli
    if [ -f $BIN ]; then
      $BIN "$@"
    else
      echo ${installUsage}
    fi
  '';
in {
  impure = stdenv.mkDerivation {
    name = "tresorit-impure-${pure.version}";
    src = ./.;
    installPhase = ''
      mkdir -p $out/bin
      install ${run-tresorit-install-script}/bin/* $out/bin
      install ${run-tresorit-script}/bin/* $out/bin
      install ${run-tresorit-cli-script}/bin/* $out/bin
    '';
  };
}
