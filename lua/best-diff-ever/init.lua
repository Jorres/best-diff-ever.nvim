local uv = require("luv")

M = {}

M.start_highlight = function ()
  print("I am highlight")

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

return M




-- -- ([30:15-20:[INSERT|MOVE]], [30:15-20:[INSERT|MOVE]])
