glib:

glib.overrideAttrs(old: {
  outputs = [ "bin" "out" "dev" ];
  mesonFlags = [
    "-Ddefault_library=static"
    "-Ddevbindir=${placeholder "dev"}/bin"
    "-Dgtk_doc=false"
    "-Dnls=disabled"
  ];
})
