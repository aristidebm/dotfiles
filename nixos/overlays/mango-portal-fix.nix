final: prev: {
   xdg-desktop-portal-wlr = prev.xdg-desktop-portal-wlr.overrideAttrs (old: {
       postInstall = (old.postInstall or "") + ''
       sed -i '/^UseIn=/ s/$/mango;/' \
       $out/share/xdg-desktop-portal/portals/wlr.portal
       '';
   });
}
