local ls = require("luasnip")
return {
    ls.snippet(
        { trig = "hi" },
        { t("Hello, world!") }
    ),
}
