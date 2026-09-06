local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("nix", {
  s("derivation", {
    t("derivation {"),
    t({ "", "  name = \"" }), i(1, ""), t("\";"),
    t({ "", "  builder = \"" }), i(2, "/bin/sh"), t("\";"),
    t({ "", "  args = [\"" }), i(3), t("\"];"),
    t({ "", "  system = \"" }), i(4, "builtins.currentSystem"), t("\";"),
    t({ "", "}" }),i(0),
  }),
  s("mkDerivation", {
    t("stdenv.mkDerivation {"),
    t({ "", "  pname = \"" }), i(1), t("\";"),
    t({ "", "  version = \"" }), i(2, "0.1.0"), t("\";"),
    t({ "", "  src = " }), i(3, "./."), t(";"),
    t({ "", "  buildInputs = [" }), i(4), t("];"),
    t({ "", "  meta = {" }),
    t({ "", "    description = \"" }), i(5), t("\";"),
    t({ "", "    homepage = \"" }), i(6), t("\";"),
    t({ "", "    license = " }), i(7, "lib.licenses.mit"), t(";"),
    t({ "", "  };", "}" }), i(0),
  }),
  s("mkShell", {
    t("pkgs.mkShell {"),
    t({ "", "  packages = [" }), i(1), t("];"),
    t({ "", "  nativeBuildInputs = [" }), i(2), t("];"),
    t({ "", "}" }), i(0),
  }),
  s("buildEnv", {
    t("pkgs.buildEnv {"),
    t({ "", "  pname = \"" }), i(1), t("\";"),
    t({ "", "  version = \"" }), i(2, "0.1.0"), t("\";"),
    t({ "", "  paths = [" }), i(3), t("];"),
    t({ "", "  meta = {" }),
    t({ "", "    description = \"" }), i(4), t("\";"),
    t({ "", "  };", "}" }), i(0),
  }),
  s("buildGoModule", {
    t("buildGoModule {"),
    t({ "", "  pname = \"" }), i(1), t("\";"),
    t({ "", "  version = \"" }), i(2, "0.1.0"), t("\";"),
    t({ "", "  src = " }), i(3, "./."), t(";"),
    t({ "", "  vendorHash = " }), i(4, "lib.fakeHash"), t(";"),
    t({ "", "  meta = {" }),
    t({ "", "    description = \"" }), i(5), t("\";"),
    t({ "", "    mainProgram  = \"" }), i(6), t("\";"),
    t({ "", "    homepage = \"" }), i(7), t("\";"),
    t({ "", "    license = " }), i(8, "lib.licenses.mit"), t(";"),
    t({ "", "  };"}),
    t({ "", "  postInstall = ''" }),
    t({ "", "     "}), i(9),
    t({ "", "  '';" }),i(0),
    t({ "", "}" }),
  }),
})
