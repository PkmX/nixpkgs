{ stdenv, fetchurl, cmake, lzma, boost, libdevil, zlib, p7zip, glibc
, openal, libvorbis, glew, freetype, xlibs, SDL, mesa, binutils
, asciidoc, libxslt, docbook_xsl, docbook_xsl_ns, curl
, jdk ? null, python ? null
, withAI ? true # support for AI Interfaces and Skirmish AIs
}:

stdenv.mkDerivation rec {

  name = "spring-${version}";
  version = "96.0";

  src = fetchurl {
    url = "mirror://sourceforge/springrts/spring_${version}_src.tar.lzma";
    sha256 = "1axyqkxgv3a0zg0afzlc7j3lyi412zd551j317ci41yqz2qzf0px";
  };

  cmakeFlags = ["-DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=ON"
                "-DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON"
                "-DPREFER_STATIC_LIBS=OFF"];

  buildInputs = [ cmake lzma boost libdevil zlib p7zip openal libvorbis freetype SDL glibc
    xlibs.libX11 xlibs.libXcursor mesa glew asciidoc libxslt docbook_xsl curl
    docbook_xsl_ns ]
    ++ stdenv.lib.optional withAI jdk
    ++ stdenv.lib.optional withAI python;

  # reported upstream http://springrts.com/mantis/view.php?id=4305
  #enableParallelBuilding = true; # occasionally missing generated files on Hydra

  meta = with stdenv.lib; {
    homepage = http://springrts.com/;
    description = "A powerful real-time strategy (RTS) game engine";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom maintainers.qknight maintainers.iElectric ];
    platforms = platforms.mesaPlatforms;
  };
}
