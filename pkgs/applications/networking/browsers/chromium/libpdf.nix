{ stdenv, fetchurl, rpm, cpio }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "libpdf-${version}";
  version = "32.0.1700.107";

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "https://dl.google.com/linux/chrome/rpm/stable/x86_64/google-chrome-stable-${version}-1.x86_64.rpm";
        sha1 = "f2d25e71b66c6c07786d8e37c35ecb9799fd15ef";
      }
    else if stdenv.system == "i686-linux" then
      fetchurl {
        url = "https://dl.google.com/linux/chrome/rpm/stable/i386/google-chrome-stable-${version}-1.i386.rpm";
        sha1 = "ae1e903a031ab2f52bf86a3cbb3f8068fcd3b586";
      }
    else throw "libpdf does not support your platform.";

  buildInputs = [ rpm cpio ];

  buildCommand =
    ''
      rpm2cpio "$src" | cpio -imd

      ensureDir $out
      cp opt/google/chrome/libpdf.so $out/libpdf.so
      patchelf --set-rpath "${stdenv.gcc.gcc}/lib:${stdenv.gcc.gcc}/lib64" $out/libpdf.so
    '';

  meta = {
    homepage = http://www.google.com/chrome;
    license = "unfree";
  };
}
