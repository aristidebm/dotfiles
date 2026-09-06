local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("python", {
  s("for", {
    t("for "),
    i(1, "value"),
    t(" in "),
    i(2, "iterable"),
    t(":"),
    t({ "", "\t" }),
    i(3, "..."),
  }),

  s("forrange", {
    t("for "),
    i(1, "value"),
    t(" in range("),
    i(2),
    t("):"),
    t({ "", "\t" }),
    i(3, "..."),
  }),

  s("forenum", {
    t("for "),
    i(1, "_"),
    t(", "),
    i(2, "value"),
    t(" in "),
    t("enumerate("),
    i(3, "iterable"),
    t("):"),
    t({ "", "\t" }),
    i(4, "..."),
  }),

  s("forzip", {
    t("for "),
    i(1, "items"),
    t(" in "),
    t("zip("),
    i(2, "iterables"),
    t("):"),
    t({ "", "\t" }),
    i(3, "..."),
  }),
  s("while", {
    t("while "),
    i(1, "condition"),
    t(":"),
    t({ "", "\t" }),
    i(2, "..."),
  }),

  s("try", {
    t("try:"),
    t({ "", "\t" }),
    i(1, "..."),
    t({ "", "except " }),
    i(2, "Exception"),
    t(" as "),
    t("exc:"),
    t({ "", "\t" }),
    t("raise exc"),
  }),

  s("tryelse", {
    t("try:"),
    t({ "", "\t" }),
    i(1, "..."),
    t({ "", "except " }),
    i(2, "Exception"),
    t(" as "),
    t("exc:"),
    t({ "", "\t" }),
    t("raise exc"),
    t({ "", "else:" }),
    t({ "", "\t" }),
    i(3, "..."),
  }),
  s("tryfinally", {
    t("try:"),
    t({ "", "\t" }),
    i(1, "..."),
    t({ "", "except " }),
    i(2, "Exception"),
    t(" as "),
    t("exc:"),
    t({ "", "\t" }),
    t("raise exc"),
    t({ "", "finally:" }),
    t({ "", "\t" }),
    i(3, "..."),
  }),

  s("def", {
    t("def "),
    i(1, "name"),
    t("("),
    i(2),
    t(") -> "),
    i(3, "None"),
    t(":"),
    t({ "", "\t" }),
    i(4, "..."),
  }),

  s("defmain", {
    t("def main() -> None:"),
    t({ "", "\t" }),
    i(1, "..."),
  }),

  s("deftest", {
    t("def test_"),
    i(1),
    t("("),
    i(2),
    t(") -> None:"),
    t({ "", "\t" }),
    i(3, "..."),
  }),

  s("definit", {
    t("def __init__(self"),
    i(1),
    t(") -> None:"),
    t({ "", "\t" }),
    i(2, "..."),
  }),

  s("defstr", {
    t("def __str__(self) -> str:"),
    t({ "", "\t" }),
    t("return "),
    i(2),
  }),

  s("defrepr", {
    t("def __repr__(self) -> str:"),
    t({ "", "\t" }),
    t("return "),
    i(2),
  }),

  s("defself", {
    t("def "),
    i(1, "name"),
    t("(self"),
    i(2),
    t(") -> "),
    i(3, "None"),
    t(":"),
    t({ "", "\t" }),
    i(4, "..."),
  }),

  s("lambda", {
    t("lambda "),
    i(1),
    t(": "),
    i(2, "expression"),
  }),

  s("class", {
    t("class "),
    i(1, "Name"),
    t(":"),
    t({ "", "\t" }),
    i(2, "..."),
  }),

  s("classe", {
    t("class "),
    i(1, "Name"),
    t("("),
    i(2),
    i(3, "enum.Enum"),
    t("):"),
    t({ "", "\t\t" }),
    i(4, "..."),
  }),



  s("with", {
    t("with "),
    i(1, "expression"),
    t(":"),
    t({ "", "\t" }),
    i(3, "..."),
  }),

  s("withas", {
    t("with "),
    i(1, "expression"),
    t(" as "),
    i(2, "alias"),
    t(":"),
    t({ "", "\t" }),
    i(3, "..."),
  }),

  s("if", {
    t("if "),
    i(1, "condition"),
    t(":"),
    t({ "", "\t" }),
    i(2, "..."),
  }),

  s("ifelse", {
    t("if "),
    i(1, "condition"),
    t(":"),
    t({ "", "\t" }),
    i(2, "..."),
    t({ "", "" }),
    t("else:"),
    t({ "", "\t" }),
    i(3, "..."),
  }),

  s("elif", {
    t("elif "),
    i(1, "condition"),
    t(":"),
    t({ "", "\t" }),
    i(2, "..."),
  }),

  s("ifmain", {
    t("if "),
    t('__name__ == "__main__":'),
    t({ "", "\t" }),
    t("main()"),
  }),

  s("ifreturn", {
    t("if "),
    i(1, "condition"),
    t(":"),
    t({ "", "\t" }),
    t("return"),
    i(2),
  }),

  s("match", {
    t("match "),
    i(1, "expression"),
    t(":"),
    t({ "", "\t" }),
    t("case "),
    i(2, "pattern"),
    t(":"),
    t({ "", "\t\t" }),
    i(3, "..."),
  }),

  s("case", {
    t("case "),
    i(1, "pattern"),
    t(":"),
    t({ "", "\t" }),
    i(2, "..."),
  }),

  s("casedefault", {
    t("case "),
    t("_:"),
    t({ "", "\t" }),
    i(1, "..."),
  }),

  s("import", {
    t("import "),
    i(1, "package"),
  }),

  s("from", {
    t("from "),
    i(1, "package"),
    t(" import "),
    i(2, "member"),
  }),

  s("printf", {
    t('print(f"{'),
    i(1),
    t('}")'),
  }),

  s("returnf", {
    t('return f"{'),
    i(1),
    t('}"'),
  }),

  s("fexpr", {
    t('f"{'),
    i(1),
    t('}"'),
  }),

  s("format", {
    t('"{}".format('),
    i(1),
    t(")"),
  }),

  s("filter", {
    t("filter("),
    i(1, "function"),
    t(", "),
    i(2, "iterable"),
    t(")"),
  }),

  s("map", {
    -- The third argument is *iterables
    t("map("),
    i(1, "function"),
    t(", "),
    i(2, "iterable"),
    i(3),
    t(")"),
  }),

  s("reduce", {
    -- The third argument is initial
    t("functools.reduce("),
    i(1, "function"),
    t(", "),
    i(2, "iterable"),
    i(3),
    t(")"),
  }),

  s("next", {
    -- The second argument is initial
    t("next("),
    i(1, "iterator"),
    i(2),
    t(")"),
  }),

  s("iter", {
    -- The second argument is initial
    t("iter("),
    i(1, "iterable"),
    t(")"),
  }),

  s("docs", {
    t('"""'),
    t({"", ""}),
    i(1, "Brief description."),
    t({"", ""}),
    t('"""'),
    i(0)
  }),

  s("docf", {
    t('"""'),
    t({"", ""}),
    i(1, "Brief description of the function."),
    t({"", "", "Args:"}),
    t({"", "    "}),
    i(2, "param1 (type): Description of param1."),
    t({"", "    "}),
    i(3, "param2 (type): Description of param2."),
    t({"", "", "Returns:"}),
    t({"", "    "}),
    i(4, "type: Description of return value."),
    t({"", '"""'}),
    i(0)
  }),

  s("docc", {
    t('"""'),
    t({"", ""}),
    i(1, "Brief description of the class."),
    t({"", "", "Attributes:"}),
    t({"", "    "}),
    i(2, "attr1 (type): Description of attr1."),
    t({"", "    "}),
    i(3, "attr2 (type): Description of attr2."),
    t({"", '"""'}),
    i(0)
  }),

  s("env", {
    t("#!/usr/bin/env python"),
  }),
})
