local M = {}

-- Insert mode non-recursive key mapping function
M.inoremap = function(lhs, rhs, silent, desc)
  vim.keymap.set("i", lhs, rhs, { noremap = true, silent = silent, desc = desc })
end

-- Normal mode non-recursive key mapping function
M.nnoremap = function(lhs, rhs, silent, desc)
  vim.keymap.set("n", lhs, rhs, { noremap = true, silent = silent, desc = desc })
end

-- Terminal mode non-recursive key mapping function
M.tnoremap = function(lhs, rhs, silent, desc)
  vim.keymap.set("t", lhs, rhs, { noremap = true, silent = silent, desc = desc })
end

-- Visual mode (inclusive) non-recursive key mapping function
M.vnoremap = function(lhs, rhs, silent, desc)
  vim.keymap.set("v", lhs, rhs, { noremap = true, silent = silent, desc = desc })
end

-- Visual mode (exclusive) non-recursive key mapping function
M.xnoremap = function(lhs, rhs, silent, desc)
  vim.keymap.set("x", lhs, rhs, { noremap = true, silent = silent, desc = desc })
end

return M
