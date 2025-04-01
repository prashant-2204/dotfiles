return {
  'nvim-neo-tree/neo-tree.nvim',                                     -- Main plugin specification
  event = 'VeryLazy',                                                -- Load plugin lazily to improve startup time
  branch = 'v3.x',                                                   -- Use version 3.x of Neo-tree
  dependencies = {                                                   -- List of plugins Neo-tree depends on
    'nvim-lua/plenary.nvim',                                         -- Utility library for Neovim plugins
    'nvim-tree/nvim-web-devicons',                                   -- Provides file icons (optional but recommended)
    'MunifTanjim/nui.nvim',                                          -- UI component library for Neovim
    '3rd/image.nvim',                                                -- Optional: Adds image preview support in Neo-tree
    {
      's1n7ax/nvim-window-picker',                                   -- Window picker plugin for opening files in specific windows
      version = '2.*',                                               -- Use version 2.x
      config = function()
        require('window-picker').setup {                             -- Configure window-picker
          filter_rules = {
            include_current_win = false,                             -- Exclude current window from picker
            autoselect_one = true,                                   -- Auto-select if only one window is available
            bo = {                                                   -- Buffer options for filtering
              filetype = { 'neo-tree', 'neo-tree-popup', 'notify' }, -- Ignore these filetypes
              buftype = { 'terminal', 'quickfix' },                  -- Ignore these buffer types
            },
          },
        }
      end,
      keys = { -- Keybindings for Neo-tree with window-picker
        { '<leader>w',   ':Neotree toggle float<CR>',         silent = true, desc = 'Float File Explorer' },
        { '<leader>e',   ':Neotree toggle position=left<CR>', silent = true, desc = 'Left File Explorer' },
        { '<leader>ngs', ':Neotree float git_status<CR>',     silent = true, desc = 'Neotree Open Git Status Window' },
      },
    },
  },
  config = function()
    -- Configure diagnostic signs globally using modern Neovim API
    -- This replaces the deprecated vim.fn.sign_define calls with original symbols
    vim.diagnostic.config {
      virtual_text = true,                                 -- Show diagnostic messages inline with code
      underline = {
        severity = { min = vim.diagnostic.severity.WARN }, -- Underline warnings and above
      },
      signs = {
        active = true, -- Enable diagnostic signs in the sign column
        text = { -- Define custom icons for each diagnostic severity (original symbols)
          [vim.diagnostic.severity.ERROR] = ' ', -- Error icon (original)
          [vim.diagnostic.severity.WARN] = '', -- Warning icon (original)
          [vim.diagnostic.severity.INFO] = ' ', -- Info icon (original)
          [vim.diagnostic.severity.HINT] = '󰌵', -- Hint icon (original)
        },
      },
    }

    -- Setup Neo-tree with its configuration
    require('neo-tree').setup {
      close_if_last_window = false, -- Don’t close Neo-tree if it’s the last window in the tab
      popup_border_style = 'rounded', -- Use rounded borders for floating windows
      enable_git_status = true, -- Show git status in the tree
      enable_diagnostics = true, -- Show diagnostics (uses vim.diagnostic.config above)
      open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' }, -- Don’t replace these buffer types when opening files
      sort_case_insensitive = false, -- Sort files case-sensitively
      sort_function = nil, -- No custom sort function (use default)
      default_component_configs = { -- Default settings for Neo-tree components
        container = {
          enable_character_fade = true, -- Fade characters for better visibility
        },
        indent = { -- Indentation settings
          indent_size = 2, -- Size of each indent level
          padding = 1, -- Padding on the left
          with_markers = true, -- Show indent markers
          indent_marker = '│', -- Vertical line for indentation
          last_indent_marker = '└', -- Marker for the last item in a group
          highlight = 'NeoTreeIndentMarker', -- Highlight group for indent markers
          with_expanders = nil, -- Enable expanders if nesting is on (nil = auto)
          expander_collapsed = '', -- Icon for collapsed directories
          expander_expanded = '', -- Icon for expanded directories
          expander_highlight = 'NeoTreeExpander', -- Highlight group for expanders
        },
        icon = { -- File and folder icons
          folder_closed = '', -- Closed folder icon
          folder_open = '', -- Open folder icon
          folder_empty = '󰜌', -- Empty folder icon
          default = '*', -- Fallback icon if nvim-web-devicons isn’t set
          highlight = 'NeoTreeFileIcon', -- Highlight group for icons
        },
        modified = { -- Indicator for modified files
          symbol = '[+]', -- Symbol for modified files
          highlight = 'NeoTreeModified', -- Highlight group for modified indicator
        },
        name = { -- File/directory name settings
          trailing_slash = false, -- Don’t show trailing slashes
          use_git_status_colors = true, -- Color names based on git status
          highlight = 'NeoTreeFileName', -- Highlight group for names
        },
        git_status = { -- Git status symbols
          symbols = {
            added = '', -- No symbol (uses name color instead)
            modified = '', -- No symbol (uses name color instead)
            deleted = '✖', -- Deleted file symbol
            renamed = '󰁕', -- Renamed file symbol
            untracked = '', -- Untracked file symbol
            ignored = '', -- Ignored file symbol
            unstaged = '󰄱', -- Unstaged changes symbol
            staged = '', -- Staged changes symbol
            conflict = '', -- Conflict symbol
          },
        },
        file_size = {           -- Show file sizes
          enabled = true,
          required_width = 64,  -- Minimum window width to show this
        },
        type = {                -- Show file types
          enabled = true,
          required_width = 122, -- Minimum window width to show this
        },
        last_modified = {       -- Show last modified time
          enabled = true,
          required_width = 88,  -- Minimum window width to show this
        },
        created = {             -- Show creation time
          enabled = true,
          required_width = 110, -- Minimum window width to show this
        },
        symlink_target = {      -- Show symlink targets
          enabled = false,
        },
      },
      commands = {},                                                   -- No custom global commands defined
      window = {                                                       -- Window settings for Neo-tree
        position = 'left',                                             -- Default position on the left
        width = 40,                                                    -- Width of the tree window
        mapping_options = {
          noremap = true,                                              -- Don’t remap existing keys
          nowait = true,                                               -- Execute mappings immediately
        },
        mappings = {                                                   -- Key mappings within Neo-tree
          ['<space>'] = { 'toggle_node', nowait = false },             -- Toggle node expansion
          ['<2-LeftMouse>'] = 'open',                                  -- Open file with double-click
          ['<cr>'] = 'open',                                           -- Open file with Enter
          ['<esc>'] = 'cancel',                                        -- Close preview or floating window
          ['P'] = { 'toggle_preview', config = { use_float = true } }, -- Toggle preview in float
          ['l'] = 'open',                                              -- Open file
          ['S'] = 'open_split',                                        -- Open in horizontal split
          ['s'] = 'open_vsplit',                                       -- Open in vertical split
          ['t'] = 'open_tabnew',                                       -- Open in new tab
          ['w'] = 'open_with_window_picker',                           -- Open using window picker
          ['C'] = 'close_node',                                        -- Close current node
          ['z'] = 'close_all_nodes',                                   -- Close all nodes
          ['a'] = { 'add', config = { show_path = 'none' } },          -- Add new file
          ['A'] = 'add_directory',                                     -- Add new directory
          ['d'] = 'delete',                                            -- Delete file/directory
          ['r'] = 'rename',                                            -- Rename file/directory
          ['y'] = 'copy_to_clipboard',                                 -- Copy to clipboard
          ['x'] = 'cut_to_clipboard',                                  -- Cut to clipboard
          ['p'] = 'paste_from_clipboard',                              -- Paste from clipboard
          ['c'] = 'copy',                                              -- Copy file/directory
          ['m'] = 'move',                                              -- Move file/directory
          ['q'] = 'close_window',                                      -- Close Neo-tree window
          ['R'] = 'refresh',                                           -- Refresh the tree
          ['?'] = 'show_help',                                         -- Show help
          ['<'] = 'prev_source',                                       -- Switch to previous source
          ['>'] = 'next_source',                                       -- Switch to next source
          ['i'] = 'show_file_details',                                 -- Show file details
        },
      },
      nesting_rules = {},          -- No custom nesting rules
      filesystem = {               -- Filesystem source settings
        filtered_items = {         -- Filtering options
          visible = false,         -- Don’t show filtered items differently
          hide_dotfiles = false,   -- Show dotfiles
          hide_gitignored = false, -- Show gitignored files
          hide_hidden = false,     -- Show hidden files (Windows)
          hide_by_name = {         -- Hide specific files/directories by name
            '.DS_Store',
            'thumbs.db',
            'node_modules',
            '__pycache__',
            '.virtual_documents',
            '.git',
            '.python-version',
            '.venv',
          },
          hide_by_pattern = {},                                                                         -- No pattern-based hiding
          always_show = {},                                                                             -- No files always shown
          never_show = {},                                                                              -- No files always hidden
          never_show_by_pattern = {},                                                                   -- No pattern-based always-hidden
        },
        follow_current_file = {                                                                         -- Auto-focus current file
          enabled = false,                                                                              -- Disabled
          leave_dirs_open = false,                                                                      -- Close auto-expanded dirs
        },
        group_empty_dirs = false,                                                                       -- Don’t group empty directories
        hijack_netrw_behavior = 'open_default',                                                         -- Replace netrw with Neo-tree
        use_libuv_file_watcher = false,                                                                 -- Use autocmds instead of OS file watchers
        window = {                                                                                      -- Filesystem-specific window settings
          mappings = {
            ['<bs>'] = 'navigate_up',                                                                   -- Go up a directory
            ['.'] = 'set_root',                                                                         -- Set current directory as root
            ['H'] = 'toggle_hidden',                                                                    -- Toggle hidden files
            ['/'] = 'fuzzy_finder',                                                                     -- Start fuzzy finder
            ['D'] = 'fuzzy_finder_directory',                                                           -- Fuzzy find directories
            ['#'] = 'fuzzy_sorter',                                                                     -- Fuzzy sort with fzy algorithm
            ['f'] = 'filter_on_submit',                                                                 -- Filter files
            ['<c-x>'] = 'clear_filter',                                                                 -- Clear filter
            ['[g'] = 'prev_git_modified',                                                               -- Previous git-modified file
            [']g'] = 'next_git_modified',                                                               -- Next git-modified file
            ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } }, -- Order-by help
            ['oc'] = { 'order_by_created', nowait = false },                                            -- Sort by creation time
            ['od'] = { 'order_by_diagnostics', nowait = false },                                        -- Sort by diagnostics
            ['og'] = { 'order_by_git_status', nowait = false },                                         -- Sort by git status
            ['om'] = { 'order_by_modified', nowait = false },                                           -- Sort by modification time
            ['on'] = { 'order_by_name', nowait = false },                                               -- Sort by name
            ['os'] = { 'order_by_size', nowait = false },                                               -- Sort by size
            ['ot'] = { 'order_by_type', nowait = false },                                               -- Sort by type
          },
          fuzzy_finder_mappings = {                                                                     -- Keymaps for fuzzy finder popup
            ['<down>'] = 'move_cursor_down',
            ['<C-n>'] = 'move_cursor_down',
            ['<up>'] = 'move_cursor_up',
            ['<C-p>'] = 'move_cursor_up',
          },
        },
        commands = {},             -- No custom filesystem commands
      },
      buffers = {                  -- Buffers source settings
        follow_current_file = {
          enabled = true,          -- Auto-focus current buffer
          leave_dirs_open = false, -- Close auto-expanded dirs
        },
        group_empty_dirs = true,   -- Group empty directories
        show_unloaded = true,      -- Show unloaded buffers
        window = {
          mappings = {
            ['bd'] = 'buffer_delete',                                                                   -- Delete buffer
            ['<bs>'] = 'navigate_up',                                                                   -- Go up a level
            ['.'] = 'set_root',                                                                         -- Set current as root
            ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } }, -- Order-by help
            ['oc'] = { 'order_by_created', nowait = false },                                            -- Sort by creation
            ['od'] = { 'order_by_diagnostics', nowait = false },                                        -- Sort by diagnostics
            ['om'] = { 'order_by_modified', nowait = false },                                           -- Sort by modification
            ['on'] = { 'order_by_name', nowait = false },                                               -- Sort by name
            ['os'] = { 'order_by_size', nowait = false },                                               -- Sort by size
            ['ot'] = { 'order_by_type', nowait = false },                                               -- Sort by type
          },
        },
      },
      git_status = {                                                                                    -- Git status source settings
        window = {
          position = 'float',                                                                           -- Show git status in a floating window
          mappings = {
            ['A'] = 'git_add_all',                                                                      -- Stage all changes
            ['gu'] = 'git_unstage_file',                                                                -- Unstage file
            ['ga'] = 'git_add_file',                                                                    -- Stage file
            ['gr'] = 'git_revert_file',                                                                 -- Revert file changes
            ['gc'] = 'git_commit',                                                                      -- Commit changes
            ['gp'] = 'git_push',                                                                        -- Push to remote
            ['gg'] = 'git_commit_and_push',                                                             -- Commit and push
            ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } }, -- Order-by help
            ['oc'] = { 'order_by_created', nowait = false },                                            -- Sort by creation
            ['od'] = { 'order_by_diagnostics', nowait = false },                                        -- Sort by diagnostics
            ['om'] = { 'order_by_modified', nowait = false },                                           -- Sort by modification
            ['on'] = { 'order_by_name', nowait = false },                                               -- Sort by name
            ['os'] = { 'order_by_size', nowait = false },                                               -- Sort by size
            ['ot'] = { 'order_by_type', nowait = false },                                               -- Sort by type
          },
        },
      },
    }

    -- Custom keybinding to reveal current file in Neo-tree
    vim.cmd [[nnoremap \ :Neotree reveal<cr>]]
  end,
}
