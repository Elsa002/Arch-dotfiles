-- Includes ------------------------------------------------------
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


-- Constants -----------------------------------------------------
-- new line
local nl = t({"", ""})

-- common types for functions
local common_return_types = {
    t("void "),
    sn(nil, {t("enum "), i(1, "enum_name"), t(" ")}),
    t("void *"),
    t("char *"),
    t("int "),
    sn(nil, {t("struct "), i(1, "struct_name"), t(" *")}),
    i(nil, "custom"),
}

-- printf types
local format_strings = {
    t("\\\"%s\\\""),
    t("%d"),
    t("%p"),
    t("%zu"),
    sn(nil, {t("0x%"), i(1, "8"), t("x")}),
    i(nil, "custom")
}

-- Functions -----------------------------------------------------
local function date(_, _, _)
	local file = io.popen("date +%Y/%m/%d", "r")
	local res = {}
    for line in file:lines() do
		table.insert(res, line)
	end	return res
end

local function fun_doc_snip(args, _, old_state)
	-- !!! old_state is used to preserve user-input here. DON'T DO IT THAT WAY!
	-- Using a restoreNode instead is much easier.
	-- View this only as an example on how old_state functions.
	local nodes = {
		t({ "/**", " * " }),
		i(1, "A short Description"),
		t({ "", "" }),
	}

	-- These will be merged with the snippet; that way, should the snippet be updated,
	-- some user input eg. text can be referred to in the new snippet.
	local param_nodes = {}

	if old_state then
		nodes[2] = i(1, old_state.descr:get_text())
	end
	param_nodes.descr = nodes[2]

	-- At least one param.
	if string.find(args[2][1], ", ") then
		vim.list_extend(nodes, { t({ " * ", "" }) })
	end

	local insert = 2
	for indx, arg in ipairs(vim.split(args[2][1], ", ", true)) do
		-- Get actual name parameter.
		arg = vim.split(arg, " ", true)[2]
		if arg then
			local inode
			-- if there was some text in this parameter, use it as static_text for this new snippet.
			if old_state and old_state[arg] then
				inode = i(insert, old_state["arg" .. arg]:get_text())
			else
				inode = i(insert)
			end
			vim.list_extend(
				nodes,
				{ t({ " * @param " .. arg .. " " }), inode, t({ "", "" }) }
			)
			param_nodes["arg" .. arg] = inode

			insert = insert + 1
		end
	end

	if args[1][1] ~= "void" then
		local inode
		if old_state and old_state.ret then
			inode = i(insert, old_state.ret:get_text())
		else
			inode = i(insert)
		end

		vim.list_extend(
			nodes,
			{ t({ " * ", " * @return " }), inode, t({ "", "" }) }
		)
		param_nodes.ret = inode
		insert = insert + 1
	end

	if vim.tbl_count(args[3]) ~= 1 then
		local exc = string.gsub(args[3][2], " throws ", "")
		local ins
		if old_state and old_state.ex then
			ins = i(insert, old_state.ex:get_text())
		else
			ins = i(insert)
		end
		vim.list_extend(
			nodes,
			{ t({ " * ", " * @throws " .. exc .. " " }), ins, t({ "", "" }) }
		)
		param_nodes.ex = ins
		insert = insert + 1
	end

	vim.list_extend(nodes, { t({ " */" }) })

	local snip = sn(nil, nodes)
	-- Error on attempting overwrite.
	snip.old_state = param_nodes
	return snip
end


-- Snippets ------------------------------------------------------
Snippets = {}

Snippets.snippets = {
    s("Includes", {
        t("/* Includes ****************************************************/")
        }
    ),

    s("Constants", {
        t("/* Constants ***************************************************/")
        }
    ),

    s("Typedefs", {
        t("/* Typedefs ****************************************************/")
        }
    ),

    s("Enums", {
        t("/* Enums *******************************************************/")
        }
    ),

    s("Structs", {
        t("/* Structs *****************************************************/")
        }
    ),

    s("Globals", {
        t("/* Globals *****************************************************/")
        }
    ),

    s("Functions", {
        t("/* Functions ***************************************************/")
        }
    ),

    s("FunDec", {
        t("/***************************************************************"), nl,
        t("    Function: "), i(1, "Function Name"), nl,
        t("***************************************************************/"), nl,
        t("enum "), i(2, "project_status"), t(" "), i(3, "function_name"), t(" (")
        }
    ),

    s("printf", {
        c(1, {
            t("(void)"),
            sn(nil, {
                i(1, "return_value"), t(" = ")
            })
        }),t("printf(\""), c(2, format_strings), t("\");")
        }
    ),
}

-- autotriggered snippets have to be defined in a separate table, luasnip.autosnippets.
Snippets.auto_snippets = {
    s("voip", {t("(void *)")})
}

return Snippets

