return {
  'mg979/vim-visual-multi',
  branch = 'master', -- Use the master branch (latest stable version)
  event = 'VeryLazy', -- Optional: Load the plugin lazily to improve startup time
  config = function()
    -- Optional: Add custom configuration here if needed
    -- vim-visual-multi works out of the box with default keybindings, but you can customize it
    -- For example, set custom mappings (defaults are <C-n>, <C-down>, etc.)
    vim.g.VM_maps = {
      ['Find Under'] = '<C-n>', -- Start multi-cursor with Ctrl+n
      ['Find Subword Under'] = '<C-n>',
      ['Add Cursor Down'] = '<C-Down>',
      ['Add Cursor Up'] = '<C-Up>',
    }
  end,
}
