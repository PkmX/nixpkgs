{ fetchurl, build_bitcoin, stdenv, glib }:

with stdenv.lib;

build_bitcoin (rec {
  nameBase = "namecoin";
  version = "0.3.51.00";

  src = fetchurl {
    url = "https://github.com/namecoin/namecoin/archive/nc${version}.tar.gz";
    sha256 = "0r6zjzichfjzhvpdy501gwy9h3zvlla3kbgb38z1pzaa0ld9siyx";
  };

  patches = [ ./namecoin_dynamic.patch ];

  extraBuildInputs = [ glib ];

  meta = {
    description = "Namecoin is a decentralized key/value registration and transfer system based on Bitcoin technology.";
    homepage = http://namecoin.info;
    maintainers = [ maintainers.offline ];
  };
})
