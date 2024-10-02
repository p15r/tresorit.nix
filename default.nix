{}:

with import <nixpkgs> {};

stdenv.mkDerivation rec {

  version = "3.5.1241.4340";
  name = "tresorit-${version}";

  src = fetchurl {
    url = https://installerstorage.blob.core.windows.net/public/install/tresorit_installer.run;
    sha256 = "763130c3da9720cc35e8051083c41d774930b860b56ade1f1b77c5b06c733b65";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ qt5.qtbase
                  fuse ];

  dontBuild = true;
  dontConfigure = true;
  dontMake = true;
  dontWrapQtApps = true;

  unpackPhase  = ''
    tail -n+93 $src | tar xz -C $TMP
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -rf $TMP/tresorit_x64/* $out/bin/
    rm $out/bin/uninstall.sh
  '';

  meta = with lib; {
    description = "Tresorit is the ultra-secure place in the cloud to store, sync and share files easily from anywhere, anytime.";
    homepage = https://tresorit.com;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ maintainers.apeyroux ];
  };
}
