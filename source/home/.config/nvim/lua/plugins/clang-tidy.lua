local clang_tidy = require('clang-tidy')

local custom_attach_clangd = function(client)
  clang_tidy.setup()
  -- rest of the attch function
end


clang_tidy.setup{
  cmd = 'clang-tidy', -- The clang-tidy command
  checks = {
    '*',
    }, -- An array of clang-tidy checks
  args = {}, -- An array clang-tidy launching args
  cwd = vim.loop.cwd, -- Function: the function to execute to get the cwd
  ignore_severity = {
    -- 'note'
  } -- An array of severity that you don't wish to publish
}

clang_tidy.run()
