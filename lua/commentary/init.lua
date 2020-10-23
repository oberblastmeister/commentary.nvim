local api = vim.api

-- local utils = require("commentary/utils")
local utils = require("utils")

local M = {}

function M.comment(range)
  local commentstring = vim.bo.commentstring

  if range then
    local lnstart = vim.fn.line("'[") - 1
    local lnend = vim.fn.line("']")
    local lines = api.nvim_buf_get_lines(0, lnstart, lnend, 1)
    for i, _ in ipairs(lines) do
      lines[i] = utils.toggle_comment(lines[i], commentstring) 
    end
    api.nvim_buf_set_lines(0, lnstart, lnend, 1, lines)
  else
    api.nvim_set_current_line(utils.toggle_comment(api.nvim_get_current_line(), commentstring))
  end
end

return M
