{ fetchurl, build_bitcoin, stdenv }:

with stdenv.lib;

build_bitcoin (rec {
  binName = "ppcoin";
  nameBase = "ppcoin";
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/ppcoin/ppcoin/archive/v${version}ppc.tar.gz";
    sha256 = "09jnl6jmam4bm3g9ajf9dyfa6wy6fnczz9rl3d1hwdwv7gwb01vc";
  };

  meta = {
    description = "Cryptocurrency using proof-of-stake.";
    homepage = http://peercoin.net;
    maintainers = [ maintainers.falsifian ];
  };
})
