local ls = require("luasnip") --{{{
local s = ls.s --> snippet
local i = ls.i --> insert node
local t = ls.t --> text node

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local snippets, autosnippets = {}, {} --}}}

local group = vim.api.nvim_create_augroup("Lua Snippets", { clear = true })
local file_pattern = "*.lua"
-- Tutorial Snippets go here --
--
--
--name, trigger,
local myFirstSnippet = s("myFirstSnippet", {
	t("Hi! this is my first snippet in LuasSnip "),
	i(1, "placeholder_text"),
	-- "" is newline
	t({ "", "This is another text node" }),
})
table.insert(snippets, myFirstSnippet)

local mySecondSnippet = s(
	"mySecondSnippet",
	fmt(
		[[
local {} = function({})
  {} {{ Double braces to escape }}
end
]],
		{
			i(1, "myVar"),
			i(2, "myArg"),
			i(3, "-- TODO: something"),
		}
	)
)
table.insert(snippets, mySecondSnippet)

local myThirdSnippet = s(
	"myThirdSnippet",
	fmt(
		[[
local {} = function({})
  {} {{ Double braces to escape }}
end
]],
		{
			i(1, "myVar"),
			c(2, { t(""), i(1, "myArg") }),
			i(3, "-- TODO: something"),
		}
	)
)
local myFirstAutoSnippet = s("auto-", { t("This was auto triggered") })
table.insert(autosnippets, myFirstAutoSnippet)

-- End Refactoring --

return snippets, autosnippets
