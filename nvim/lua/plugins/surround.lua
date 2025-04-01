
return {
  "kylechui/nvim-surround",
  version = "*", -- Use the latest stable version
  event = "VeryLazy", -- Load when needed
  config = function()
    require("nvim-surround").setup({})
  end
}
