local ls = require("luasnip") --{{{
local s = ls.s
local i = ls.i
local t = ls.t

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local snippets, autosnippets = {}, {} --}}}

local group = vim.api.nvim_create_augroup("Javascript Snippets", { clear = true })
local file_pattern = "*.js, *.jsx, *.tsx, *.ts"

local function cs(trigger, nodes, opts) --{{{
	local snippet = s(trigger, nodes)
	local target_table = snippets

	local pattern = file_pattern
	local keymaps = {}

	if opts ~= nil then
		-- check for custom pattern
		if opts.pattern then
			pattern = opts.pattern
		end

		-- if opts is a string
		if type(opts) == "string" then
			if opts == "auto" then
				target_table = autosnippets
			else
				table.insert(keymaps, { "i", opts })
			end
		end

		-- if opts is a table
		if opts ~= nil and type(opts) == "table" then
			for _, keymap in ipairs(opts) do
				if type(keymap) == "string" then
					table.insert(keymaps, { "i", keymap })
				else
					table.insert(keymaps, keymap)
				end
			end
		end

		-- set autocmd for each keymap
		if opts ~= "auto" then
			for _, keymap in ipairs(keymaps) do
				vim.api.nvim_create_autocmd("BufEnter", {
					pattern = pattern,
					group = group,
					callback = function()
						vim.keymap.set(keymap[1], keymap[2], function()
							ls.snip_expand(snippet)
						end, { noremap = true, silent = true, buffer = true })
					end,
				})
			end
		end
	end

	table.insert(target_table, snippet) -- insert snippet into appropriate table
end --}}}

-- Old Style --

local if_fmt_arg = { --{{{
	i(1, ""),
	c(2, { i(1, "LHS"), i(1, "10") }),
	c(3, { i(1, "==="), i(1, "<"), i(1, ">"), i(1, "<="), i(1, ">="), i(1, "!==") }),
	i(4, "RHS"),
	i(5, "//TODO:"),
}
local if_fmt_1 = fmt(
	[[
                                                                                                                                                                                                                                                                     {}if ({} {} {}) {};
                                                                                                                                                                                                                                                                         ]],
	vim.deepcopy(if_fmt_arg)
)
local if_fmt_2 = fmt(
	[[
                                                                                                                                                                                                                                                                             {}if ({} {} {}) {{
                                                                                                                                                                                                                                                                               {};
                                                                                                                                                                                                                                                                               }}
                                                                                                                                                                                                                                                                                   ]],
	vim.deepcopy(if_fmt_arg)
)

local if_snippet = s(
	{ trig = "IF", regTrig = false, hidden = true },
	c(1, {
		if_fmt_1,
		if_fmt_2,
	})
) --}}}
local function_fmt = fmt( --{{{
	[[
                                                                                                                                                                                                                                                                                                     function {}({}) {{
                                                                                                                                                                                                                                                                                                       {}
                                                                                                                                                                                                                                                                                                       }}
                                                                                                                                                                                                                                                                                                           ]],
	{
		i(1, "myFunc"),
		c(2, { i(1, "arg"), i(1, "") }),
		i(3, "//TODO:"),
	}
)

local function_snippet = s({ trig = "f[un]?", regTrig = true, hidden = true }, function_fmt)
local function_snippet_func = s({ trig = "func" }, vim.deepcopy(function_fmt)) --}}}

local short_hand_if_fmt = fmt( --{{{
	[[
                                                                                                                                                                                                                                                                                                                             if ({}) {}
                                                                                                                                                                                                                                                                                                                             {}
                                                                                                                                                                                                                                                                                                                                 ]],
	{
		d(1, function(_, snip)
			-- return sn(1, i(1, snip.captures[1]))
			return sn(1, t(snip.captures[1]))
		end),
		d(2, function(_, snip)
			return sn(2, t(snip.captures[2]))
		end),
		i(3, ""),
	}
)
local short_hand_if_statement = s({ trig = "if[>%s](.+)>>(.+)\\", regTrig = true, hidden = true }, short_hand_if_fmt)

local short_hand_if_statement_return_shortcut = s({ trig = "(if[>%s].+>>)[r<]", regTrig = true, hidden = true }, {
	f(function(_, snip)
		return snip.captures[1]
	end),
	t("return "),
}) --}}}
table.insert(autosnippets, if_snippet)
table.insert(autosnippets, short_hand_if_statement)
table.insert(autosnippets, short_hand_if_statement_return_shortcut)
table.insert(snippets, function_snippet)
table.insert(snippets, function_snippet_func)

-- local consolelog = s(
-- 	"cl",
-- 	fmt(
-- 		[[
--     console.log({})
--     ]],
-- 		{
-- 			i(1, "myVar"),
-- 		}
-- 	)
-- )
-- hidden = true -- hides from cmp/ autosnippets hidden by default
-- local autoSnippet = s({ trig = "digit%d%d", regTrig = true , hidden = false}, { t("this was auto triggered") })
local functionSnippet = s({ trig = "digit(%d)(%d)", regTrig = true }, {
	f(function(_, snip)
		return snip.captures[1] .. " and "
	end),
	f(function(_, snip)
		return snip.captures[2]
	end),
})
local _functionSnippet = s({ trig = "digit(%d)(%d)", regTrig = true }, {
	-- i(1, "uppercase me"),
	f(function(arg, snip)
		return arg[1][1]:upper() .. arg[2][1]:lower()
	end, { 1, 2 }),
	-- i(2, "LOWERCASE ME"),
})

local consolelog = s("cl;", fmt([[console.log({})]], { i(1, "myvar") }))
local consoleloghello = s("clh;", { t('console.log("hello")') })
local classname = s("cn;", fmt([[className="{}"]], { i(1, "class") }))
local usestate = s("us;", { t("const [state, useState] = useState()") })
-- local usestate = s("us;", fmt([[const [{}, {}] = useState()]], { i(1, "myvar") }))
table.insert(autosnippets, usestate)

-- local test = s("cl;", fmt([[console.log({})]], { i(1, "myvar") }))
-- local test = s("cl;", fmt([[console.log({})]], { i(1, "myvar") }))
-- local test = s("cl;", fmt([[console.log({})]], { i(1, "myvar") }))

table.insert(autosnippets, _functionSnippet)
table.insert(autosnippets, consolelog)
table.insert(autosnippets, consoleloghello)
table.insert(autosnippets, functionSnippet)
table.insert(autosnippets, classname)
-- table.insert(snippets, consolelog)

-- End Refactoring --

return snippets, autosnippets
