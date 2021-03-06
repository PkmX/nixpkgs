{ stdenv, fetchurl, pkgconfig, mesa_noglu, glib, gdk_pixbuf, xorg, libintlOrEmpty
, pangoSupport ? true, pango, cairo, gobjectIntrospection, wayland }:

let
  ver_maj = "1.16";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "cogl-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/cogl/${ver_maj}/${name}.tar.xz";
    sha256 = "153014xygwyz9wmvgfwjxncqgc0qqvcy6b3jx1zdl3q5d9iw9hkm";
  };

  nativeBuildInputs = [ pkgconfig ];

  configureFlags = [
    "--enable-introspection"
    "--enable-gles1"
    "--enable-gles2"
    "--enable-kms-egl-platform"
    "--enable-wayland-egl-platform"
    "--enable-wayland-egl-server"
  ];

  propagatedBuildInputs = with xorg; [
      glib gdk_pixbuf gobjectIntrospection
      mesa_noglu libXrandr libXfixes libXcomposite libXdamage wayland
    ]
    ++ libintlOrEmpty;

  buildInputs = stdenv.lib.optionals pangoSupport [ pango cairo ];

  COGL_PANGO_DEP_CFLAGS
    = stdenv.lib.optionalString (stdenv.isDarwin && pangoSupport)
      "-I${pango}/include/pango-1.0 -I${cairo}/include/cairo";

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  #doCheck = true; # all tests fail (no idea why)

  meta = with stdenv.lib; {
    description = "A small open source library for using 3D graphics hardware for rendering";
    maintainers = with maintainers; [ lovek323 ];

    longDescription = ''
      Cogl is a small open source library for using 3D graphics hardware for
      rendering. The API departs from the flat state machine style of OpenGL
      and is designed to make it easy to write orthogonal components that can
      render without stepping on each other's toes.
    '';

    platforms = stdenv.lib.platforms.mesaPlatforms;
  };
}
