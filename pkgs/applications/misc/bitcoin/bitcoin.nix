{ fetchurl, build_bitcoin, stdenv }:

with stdenv.lib;

build_bitcoin (rec {
  nameBase = "bitcoin";
  version = "0.8.5";

  src = fetchurl {
    url = "https://github.com/bitcoin/bitcoin/archive/v${version}.tar.gz";
    sha256 = "196fxnps7idqi2aw4ingapid2wm3d81z51yjf41m6b9956m71w9r";
  };

  meta = {
    description = "Bitcoin is a peer-to-peer currency";
    longDescription= ''
      Bitcoin is a free open source peer-to-peer electronic cash system that is
      completely decentralized, without the need for a central server or trusted
      parties.  Users hold the crypto keys to their own money and transact directly
      with each other, with the help of a P2P network to check for double-spending.
    '';
    homepage = http://www.bitcoin.org/;
    maintainers = [ maintainers.roconnor maintainers.offline ];
  };
})
