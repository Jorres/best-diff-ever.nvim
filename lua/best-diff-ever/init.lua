local uv = require("luv")
local ns = -1

M = {}

M.communicate = function ()
  Stdin =  vim.loop.new_pipe(false)
  Stdout = vim.loop.new_pipe(false)
  Stderr = vim.loop.new_pipe(false)

  -- TODO later refactor to neovim-relative path
  Handle, Pid = uv.spawn("/home/jorres/hobbies/plugins/best-diff-ever.nvim/lua/best-diff-ever/call_lib.sh",
  {
    args = {"abcd"},
    stdio = {Stdin, Stdout, Stderr}
  },
  function (code, signal)
    -- print("code and signal", code, signal)
    vim.loop.close(Handle, function()
      -- print("process closed", Handle, Pid)
    end)
  end)

  uv.read_start(Stdout, function(err, data)
    assert(not err, err)
    if data then
      print(data)
    else
      print("Stream end")
    end
  end)

  uv.read_start(Stderr, function(err, data)
    assert(not err, err)
    if data then
      print(data)
    else
      print("Stream end")
    end
  end)
end

M.start_highlight = function ()
  vim.api.nvim_buf_add_highlight(0, ns, "MyBestEver", 3, 3, 5)
  vim.api.nvim_buf_add_highlight(0, ns, "MyBestEver", 5, 3, 5)
end

M.clear_highlight = function ()
  vim.api.nvim_exec("hi clear MyBestEver", true)
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
end

M.setup = function ()
  local hi_out = vim.api.nvim_exec("hi MyBestEver guifg=#F00000 guibg=#00F000", true)
  ns = vim.api.nvim_create_namespace("best-diff-ever-highlight")
end

-- create_win
-- get current file path
-- local filepath = vim.api.nvim_exec("echo @%", true)
return M

-- ([30:15-20:[INSERT|MOVE]], [30:15-20:[INSERT|MOVE]])
--
--
-- local tbl = {}
-- table.insert(tbl, "myvalue")
-- tbl['key'] = "keyvalue"
-- -- P(tbl)
-- -- metatables

-- for index, value in ipairs(tbl) do
--   print(index, value)
-- end

-- for key, value in pairs(tbl) do
--   print(key, value)
-- end

-- -- lua - interpreted, weak typing
-- -- indexing from 1
-- --
-- local a = 5
-- a = "abc"
-- print(a)
