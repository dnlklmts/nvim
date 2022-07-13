local colorscheme = "onedark"

local status_ok, theme = pcall(require, colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end

theme.setup {
    style = "cool"
}
theme.load()
