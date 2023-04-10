local webdevicons = require('nvim-web-devicons')
local hl_icon = '%#BuffarIcon#'
local hl_file = '%#BuffarFile#'
local hl_separator = '%#BuffarSeparator#'
local hl_tabline = '%#BuffarTabline#'
local left_separator = hl_separator .. ''
local right_separator = hl_separator .. ''
-- local left_separator = hl_separator .. ''
-- local right_separator = hl_separator .. ''
local pad_between_tabs = ''
local pad_into_tab = ' '

local default_colors = {
  background = "#1e222a",
  foreground = "#bbc2cf",
  inactive = {
    guifg = "#5b6268",
    guibg = "#1e222a",
  },
  active = {
    guifg = "#bbc2cf",
    guibg = "#282c34",
  },
}

local function center(s, width, char)
    char = char or " "
    local len = #s
    if len >= width then 
      s = '  ' .. string.sub(s, 1, width - 7) .. "...  "
      return s 
    end
    local pad = width - len
    local left = math.floor(pad / 2)
    local right = pad - left
    return string.rep(char, left) .. s .. string.rep(char, right)
end

local s = "Folder"
local n = 30
local c = " "

local padded_s = center(s, 30, ' ')
 
function get_file_icon(file)
  local file_name = vim.fn.fnamemodify(file, ':t')
  local extension = vim.fn.fnamemodify(file, ':e')
  local icon, icon_color = webdevicons.get_icon(file_name, extension, { return_color = true })

  if icon == nil then
    return ''
  else
    return '%#' .. icon_color .. '#' .. icon
  end
end

function get_tab(buffer_name)
  local icon = get_file_icon(buffer_name)
  local file_name = vim.fn.fnamemodify(buffer_name, ':t')
  local file_name_color =  hl_file .. file_name 
  local tab = left_separator .. hl_file .. pad_into_tab .. icon .. ' ' .. file_name_color .. pad_into_tab .. right_separator

  return tab
end

function get_buffer_tabline()
  local tabline = {}
  local current_bufnr = vim.api.nvim_get_current_buf()
  local total_buffers = vim.fn.bufnr('$')

  for bufnr = 1, total_buffers do
    local buffer_name = vim.fn.bufname(bufnr)
    if buffer_name ~= '' and vim.fn.bufloaded(bufnr) == 1 then
      local buffer_sign = ''
      if bufnr == current_bufnr then
      else
      end
      if buffer_name == 'NvimTree_1' then
        -- table.insert(tabline, 1, '          Tree file           ')
        table.insert(tabline, 1, padded_s)
      else
        local tab = get_tab(buffer_name)
        table.insert(tabline, tab)
      end
    end
  end
  table.insert(tabline, hl_tabline)
  return table.concat(tabline, spaces)
end

vim.cmd([[highlight BuffarIcon guifg=#439FBD]])
vim.cmd([[highlight BuffarFile guifg=#DFEDC7]])
vim.cmd([[highlight BuffarTabline guibg=#000000]])
vim.cmd([[highlight BuffarSeparator guifg=#192124 guibg=#000000]])
vim.o.tabline = '%!v:lua.get_buffer_tabline()'
vim.o.showtabline = 2
