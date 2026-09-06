local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("nix", {
  s("import", {
    t("import "),
    i(1, "<nixpkgs>"),
    t(" { "),
    i(2),
    t(" }"), i(0),
  }),
  s("inherit", {
    t("inherit "),
    i(1),
    t(";"), i(0),
  }),
  s("inheritf", {
    t("inherit ("),
    i(1),
    t(") "),
    i(2),
    t(";"), i(0),
  }),
  s("callPackage", {
    t("pkgs.callPackage "),
    i(1, "./default.nix"),
    t(" { "),
    i(2),
    t(" }"), i(0),
  }),
  s("letin", {
    t("let"),
    t({ "", "  " }), i(1),
    t({ "", "in" }),
    t({ "", "  " }), i(2), i(0),
  }),
  s("if", {
    t("if "), i(1),
    t(" then "), i(2),
    t(" else "), i(3), i(0),
  }),
  s("with", {
    t("with "), i(1, "pkgs"), t(";"),
    t({ "", "  " }), i(2), i(0),
  }),
  s("lambda", {
    i(1, "arg"), t(": "), i(2), i(0),
  }),
  s("writeShellScriptBin", {
    t("pkgs.writeShellScriptBin "),
    i(1, "name"),
    t(" ''"),
    t({ "", "  " }), i(2),
    t({ "", "''" }), i(0),
  }),
  s("writeTextFile", {
    t("pkgs.writeTextFile {"),
    t({ "", "  name = \"" }), i(1), t("\";"),
    t({ "", "  text = ''" }),
    t({ "", "    " }), i(2),
    t({ "", "  '';" }),
    t({ "", "}" }), i(0),
  }),
  s("runCommand", {
    t("pkgs.runCommand "),
    i(1, "name"),
    t(" { "),
    i(2),
    t(" } ''"),
    t({ "", "  " }), i(3),
    t({ "", "''" }), i(0),
  }),
  s("optionalString", {
    t("pkgs.lib.optionalString "),
    i(1, "cond"),
    t(" "),
    i(2, "\"value\""), i(0),
  }),
})
