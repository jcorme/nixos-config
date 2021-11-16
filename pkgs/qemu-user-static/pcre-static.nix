pcre:

pcre.overrideAttrs(old: {
  configureFlags = old.configureFlags ++ [ "--enable-static" ];
})
