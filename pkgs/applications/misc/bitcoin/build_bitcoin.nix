{ stdenv, openssl, db4, boost, zlib, miniupnpc, qt4, glib, config }:

a:

with stdenv.lib;

let

  buildBitcoin = headless: stdenv.mkDerivation ({
    name = if headless
      then "${a.nameBase}-headless-${a.version}"
      else "${a.nameBase}-gui-${a.version}";

    buildInputs = [ openssl db4 boost zlib miniupnpc ] ++ (if headless then [] else [ qt4 ]) ++ a.extraBuildInputs or [];
    configurePhase = if headless then "" else "qmake";
    installPhase = if headless then
      ''install -D "${a.nameBase}d" "$out/bin/${a.nameBase}d"''
      else
      ''install -D "${a.nameBase}-qt" "$out/bin/${a.nameBase}-qt"'';
    preBuild = if headless then "cd src" else "";
    makefile = if headless then "makefile.unix" else "";
    meta = {
      platforms = platforms.unix;
      license = license.mit;
    };
  } // a);

in

{
  gui = buildBitcoin false;
  headless = buildBitcoin true;
}
