local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("python", {

  s("@data", {
    t("@dataclasses.dataclass"),
    t({ "", "" }),
    t("class "),
    i(1, "Name"),
    t(":"),
    t({ "", "\t" }),
    i(2, "..."),
  }),

  s("@prop", {
    t("@property"),
    t({ "", "def " }),
    i(1, "name"),
    t("(self) -> "),
    i(2, "None"),
    t(":"),
    t({ "", "\t" }),
    t("return "),
    i(3, "expression"),
  }),

  s("@class", {
    t("@classmethod"),
    t({ "", "def " }),
    i(1, "name"),
    t("(cls"),
    i(2),
    t(") -> "),
    i(3, "None"),
    t(":"),
    t({ "", "\t" }),
    i(4, "..."),
  }),

  s("@stat", {
    t("@staticmethod"),
    t({ "", "def " }),
    i(1, "name"),
    t("("),
    i(2),
    t(") -> "),
    i(3, "None"),
    t(":"),
    t({ "", "\t" }),
    i(4, "..."),
  }),

  s("@abstract", {
    t("@abc.abstractmethod"),
    t({ "", "def " }),
    i(1, "name"),
    t("("),
    i(2),
    t(") -> "),
    i(3, "None"),
    t(":"),
    t({ "", "\t" }),
    i(4, "..."),
  }),

  s("@patch", {
    t("@unittest.mock.patch("),
    i(1),
    t(")"),
    t({ "", "def " }),
    i(2, "test"),
    t("("),
    i(3),
    t(") -> "),
    i(4, "None"),
    t(":"),
    t({ "", "\t" }),
    i(5, "..."),
  }),

  s("@context", {
    t("@contextlib.contextmanager"),
    t({ "", "def " }),
    i(1, "name"),
    t("("),
    i(2),
    t(") -> Generator["),
    i(3, ""),
    t("]"),
    t(":"),
    t({ "", "\t" }),
    i(4, "..."),
    t({ "", "\tyield"}),
    t({ "", "\t" }),
    i(5, "..."),
  }),

  s("@wraps", {
    t("@functools.wraps("),
    i(1),
    t(")"),
    t({ "", "def " }),
    i(2, "name"),
    t("("),
    i(3),
    t(") -> "),
    i(4, "None"),
    t(":"),
    t({ "", "\t" }),
    i(5, "..."),
  }),

  s("@cache", {
    t("@functools.cache("),
    i(1),
    t(")"),
    t({ "", "def " }),
    i(2, "name"),
    t("("),
    i(3),
    t(") -> "),
    i(4, "None"),
    t(":"),
    t({ "", "\t" }),
    i(5, "..."),
  }),

  s("@override", {
    t("@typing.override"),
    t({ "", "def " }),
    i(1, "name"),
    t("("),
    i(2),
    t(") -> "),
    i(3, "None"),
    t(":"),
    t({ "", "\t" }),
    i(4, "..."),
  }),

})
