local colorscheme = require("colorscheme")
return {
    "lualine.nvim",
    lazy = false,
    after = function()
        local function hello()
            return [[hello world]]
        end

        require("lualine").setup({
            options = {
                theme = {
                    normal = {
                        a = { bg = colorscheme.blue, fg = colorscheme.bg, gui = 'bold' },
                        b = { bg = colorscheme.darkgray, fg = colorscheme.fg },
                        c = { bg = colorscheme.darkgray, fg = colorscheme.fg },
                    },
                    insert = {
                        a = { bg = colorscheme.green, fg = colorscheme.bg, gui = 'bold' },
                        b = { bg = colorscheme.darkgray, fg = colorscheme.fg },
                        c = { bg = colorscheme.darkgray, fg = colorscheme.fg },
                    },
                    visual = {
                        a = { bg = colorscheme.yellow, fg = colorscheme.bg, gui = 'bold' },
                        b = { bg = colorscheme.darkgray, fg = colorscheme.fg },
                        c = { bg = colorscheme.darkgray, fg = colorscheme.fg },
                    },
                    replace = {
                        a = { bg = colorscheme.red, fg = colorscheme.bg, gui = 'bold' },
                        b = { bg = colorscheme.darkgray, fg = colorscheme.fg },
                        c = { bg = colorscheme.bg, fg = colorscheme.fg },
                    },
                    command = {
                        a = { bg = colorscheme.magenta, fg = colorscheme.bg, gui = 'bold' },
                        b = { bg = colorscheme.darkgray, fg = colorscheme.fg },
                        c = { bg = colorscheme.darkgray, fg = colorscheme.fg },
                    },
                    inactive = {
                        a = { bg = colorscheme.bg, fg = colorscheme.gray, gui = 'bold' },
                        b = { bg = colorscheme.bg, fg = colorscheme.gray },
                        c = { bg = colorscheme.bg, fg = colorscheme.gray },
                    }
                },
                icons_enabled = true,
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                -- disabled_filetypes = {
                --     statusline = {},
                --     winbar = {},
                -- },
                -- ignore_focus = {},
                -- always_divide_middle = true,
                -- always_show_tabline = true,
                globalstatus = true,
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = {},
                lualine_c = { 'filename', 'branch', 'diff', 'diagnostics' },
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            },
            -- tabline = {},
            tabline = {
              lualine_a = {
                {
                  'buffers',
                  show_filename_only = true,
                  hide_filename_extension = false,
                  show_modified_status = true,

                  mode = 2,

                  max_length = vim.o.columns * 2 / 3,

                  filetype_names = {
                    TelescopePrompt = 'Telescope',
                    dashboard = 'Dashboard',
                    packer = 'Packer',
                    fzf = 'FZF',
                    alpha = 'Alpha'
                  },

                  use_mode_colors = true,

                  symbols = {
                    modified = ' ●',
                    alternate_file = '',
                    directory = '',
                  },

                  buffers_color = {
                    active = {
                      fg = colorscheme.bg,
                    },

                    inactive = {
                      bg = colorscheme.darkgray,
                      fg = colorscheme.lightgray,
                    },
                  },

                }
              },

              lualine_z = {
                {
                  function()
                    return 'buffers'
                  end,
                }
              }
            },
            winbar = {},
            inactive_winbar = {},
            extensions = {}
        })
    end
}
