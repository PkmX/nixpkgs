{ stdenv, fetchurl, pkgconfig, intltool, gtk3, json_glib, curl }:


stdenv.mkDerivation rec {
  name = "transmission-remote-gtk-1.1.1";

  src = fetchurl {
    url = "http://transmission-remote-gtk.googlecode.com/files/${name}.tar.gz";
    sha256 = "1jbh2pm4i740cmzqd2r7zxnqqipvv2v2ndmnmk53nqrxcbgc4nlz";
  };

  buildInputs = [ pkgconfig intltool gtk3 json_glib curl ];

  meta = {
   description = "GTK remote control for the Transmission BitTorrent client";
  };
}
