{ fetchurl, build_bitcoin, stdenv }:

with stdenv.lib;

build_bitcoin (rec {
  binName = "litecoin";
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
})
