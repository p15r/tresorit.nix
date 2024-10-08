{}:

with import <nixpkgs> {};

stdenv.mkDerivation rec {

  version = "3.5.1244.4360";
  name = "tresorit-${version}";

  src = fetchurl {
    url = https://installerstorage.blob.core.windows.net/public/install/tresorit_installer.run;
    sha256 = "865bf2e54791546e9637823671ca5475091b6f8a2599c668040d3feed092b6ee";
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
