{ fetchurl, glib, glib-static ? (import ./glib-static.nix glib), glibc
, lib, meson, ninja, pcre, pcre-static ? (import ./pcre-static.nix pcre)
, perl, pkg-config, python3, stdenv, util-linux, zlib }:

stdenv.mkDerivation rec {
  pname = "qemu-user-static";
  version = "6.1.0";

  src = fetchurl {
    url = "https://download.qemu.org/qemu-${version}.tar.xz";
    sha256 = "15iw7982g6vc4jy1l9kk1z9sl5bm1bdbwr74y7nvwjs1nffhig7f";
  };

  nativeBuildInputs = [
    glib-static
    glibc.out
    glibc.static
    meson
    ninja
    pcre-static
    perl
    pkg-config
    python3
    util-linux
    zlib.static
  ];

  dontUseMesonConfigure = true;

  configureFlags = [
    "--static"
    "--disable-system"
    "--enable-linux-user"
    "--disable-blobs"
    "--disable-brlapi"
    "--disable-cap-ng"
    "--disable-capstone"
    "--disable-curl"
    "--disable-curses"
    "--disable-docs"
    "--disable-gcrypt"
    "--disable-gnutls"
    "--disable-gtk"
    "--disable-guest-agent"
    "--disable-guest-agent-msi"
    "--disable-libiscsi"
    "--disable-libnfs"
    "--disable-mpath"
    "--disable-nettle"
    "--disable-opengl"
    "--disable-pie"
    "--disable-sdl"
    "--disable-spice"
    "--disable-tools"
    "--disable-vte"
    "--disable-werror"
    "--disable-debug-info"
    "--disable-glusterfs"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];

  doCheck = false;
  dontPatchELF = true;
  noAuditTmpdir = true;

  postPatch = ''
    sed -i "/install_subdir('run', install_dir: get_option('localstatedir'))/d" \
        qga/meson.build
  '';

  preConfigure = ''
    chmod +x ./scripts/shaderinclude.pl
    patchShebangs .
  '';

  preBuild = "cd build";

  postInstall = ''
    for f in $out/bin/*; do mv $f $f-static; done
  '';

  meta = with lib; {
    homepage = "http://www.qemu.org/";
    description = "A generic and open source machine emulator and virtualizer (static binaries)";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
