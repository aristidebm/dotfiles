final: prev: {
  xdg-desktop-portal-wlr = prev.xdg-desktop-portal-wlr.overrideAttrs (old: rec {
    version = "0.8.2";
    src = prev.fetchFromGitHub {
      owner = "emersion";
      repo = "xdg-desktop-portal-wlr";
      rev = "01171a150b705cf07066ebc0fb7e1ff537027bec";
      sha256 = "sha256-HITf/hgiASWvn/z49mzS8IS1vuyXwdk1JiAOOHRSQMo=";
    };
    postInstall = (old.postInstall or "") + ''
      sed -i '/^UseIn=/ s/$/mango;/' \
        $out/share/xdg-desktop-portal/portals/wlr.portal
    '';
  });
}
