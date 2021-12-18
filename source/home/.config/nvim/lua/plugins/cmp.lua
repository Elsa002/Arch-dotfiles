local present, cmp = pcall(require, "cmp")
if not present then
  return
end
local lspkind = require("lspkind")

cmp.setup {
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  formatting = {
    format = lspkind.cmp_format({ with_text = false, maxwidth = 50 })
  },
  mapping = {
    -- ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    -- ["<C-f>"] = cmp.mapping.scroll_docs(4),


    -- <C-Space> and <C-e> to show/hide completions.
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),


    -- <CR> to select completion
    ["<CR>"] = cmp.mapping.confirm({ select = true }),


    -- <C-j> and <C-k> for jumping in luasnip
    ["<C-j>"] = function(fallback)
      if require("luasnip").expand_or_jumpable() then
         vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
      else
         -- fallback()
      end
    end,
    ["<C-k>"] = function(fallback)
      if require("luasnip").jumpable(-1) then
         vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
      else
         -- fallback()
      end
    end,


    -- <Tab> and <S-Tab> for selecting next/prev item
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
         cmp.select_next_item()
      -- elseif require("luasnip").expand_or_jumpable() then
      --    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
      else
         fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
         cmp.select_prev_item()
      -- elseif require("luasnip").jumpable(-1) then
      --    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
      else
         fallback()
      end
    end,
  },
  sources = {
    { name = "luasnip" },
    { name = "path" },
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "nvim_lua" }
  },
}
