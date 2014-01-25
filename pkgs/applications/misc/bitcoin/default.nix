{ fetchurl, fetchgit, stdenv, openssl, db4, boost, zlib, miniupnpc, qt4, glib }:

with stdenv.lib;

let

  buildBitcoinPackage = a@{binName ? "bitcoin", ...}: stdenv.mkDerivation ({
    buildInputs = [ openssl db4 boost zlib miniupnpc qt4 glib ] ++ a.extraBuildInputs or [];
    configurePhase = "qmake";
    installPhase = "install -D ${binName}-qt $out/bin/${binName}-qt";
    meta = {
      platforms = platforms.unix;
      license = license.mit;
    };
  } // a);

  buildBitcoinPackageHeadless = a@{binName ? "bitcoin", ...}: stdenv.mkDerivation ({
    buildInputs = [ openssl db4 boost zlib miniupnpc glib ] ++ a.extraBuildInputs or [];
    preBuild = "cd src";
    makefile = "makefile.unix";
    installPhase = "install -D ${binName}d $out/bin/${binName}";
    meta = {
      platforms = platforms.unix;
      license = license.mit;
    };
    passthru.binName = binName;
  } // a);


  bitcoin = rec {
    name = "bitcoin-${version}";
    version = "0.8.6";

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
  };

  litecoin = rec {
    binName = "litecoin";
    name = "litecoin-${version}";
    version = "0.8.5.3-rc3";

    src = fetchurl {
      url = "https://github.com/litecoin-project/litecoin/archive/v${version}.tar.gz";
      sha256 = "1z4a7bm3z9kd7n0s38kln31z8shsd32d5d5v3br5p0jlnr5g3lk7";
    };

    meta = {
      description = "Litecoin is a lite version of Bitcoin using scrypt as a proof-of-work algorithm.";
      longDescription= ''
        Litecoin is a peer-to-peer Internet currency that enables instant payments
        to anyone in the world. It is based on the Bitcoin protocol but differs
        from Bitcoin in that it can be efficiently mined with consumer-grade hardware.
        Litecoin provides faster transaction confirmations (2.5 minutes on average)
        and uses a memory-hard, scrypt-based mining proof-of-work algorithm to target
        the regular computers and GPUs most people already have.
        The Litecoin network is scheduled to produce 84 million currency units.
      '';
      homepage = https://litecoin.org/;
      maintainers = [ maintainers.offline ];
    };
  };

  namecoin = rec {
    binName = "namecoin";
    name = "namecoin-${version}";
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
  };

  ppcoin = rec {
    binName = "ppcoin";
    name = "ppcoin-${version}";
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
  };


in {
  inherit buildBitcoinPackage buildBitcoinPackageHeadless;

  bitcoin-qt = buildBitcoinPackage bitcoin;
  bitcoin = buildBitcoinPackageHeadless bitcoin;
  litecoin-qt = buildBitcoinPackage litecoin;
  litecoin = buildBitcoinPackageHeadless litecoin;
  namecoin-qt = buildBitcoinPackage namecoin;
  namecoin = buildBitcoinPackageHeadless namecoin;
  ppcoin-qt = buildBitcoinPackage ppcoin;
  ppcoin = buildBitcoinPackageHeadless ppcoin;
}
