local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local l = require("luasnip.extras").lambda
local r = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

-- Every unspecified option will be set to the default.
ls.config.set_config({
	history = true,
	-- Update more often, :h events for more info.
	updateevents = "TextChanged,TextChangedI",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "choiceNode", "Comment" } },
			},
		},
	},
	-- treesitter-hl has 100, use something higher (default is 200).
	ext_base_prio = 200,
	-- minimal increase in priority.
	ext_prio_increase = 1,
	enable_autosnippets = true,
})

ls.snippets = {
    all = require("snippets/all_snippets").snippets,
    c = require("snippets/c_snippets").snippets,
    cpp = require("snippets/cpp_snippets").snippets,
    python = require("snippets/python_snippets").snippets,
    sh = require("snippets/sh_snippets").snippets,
    bash = require("snippets/bash_snippets").snippets,
    zsh = require("snippets/zsh_snippets").snippets,
}

-- autotriggered snippets have to be defined in a separate table, luasnip.autosnippets.
ls.autosnippets = {
    all = require("snippets/all_snippets").auto_snippets,
    c = require("snippets/c_snippets").auto_snippets,
    cpp = require("snippets/cpp_snippets").auto_snippets,
    python = require("snippets/python_snippets").auto_snippets,
    sh = require("snippets/sh_snippets").auto_snippets,
    bash = require("snippets/bash_snippets").auto_snippets,
    zsh = require("snippets/zsh_snippets").auto_snippets,
}

ls.filetype_extend("cpp", { "c" })
ls.filetype_extend("zsh", { "sh" })
ls.filetype_extend("bash", { "sh" })
