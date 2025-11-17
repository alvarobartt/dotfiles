vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.opt.foldenable = false
vim.opt.foldmethod = "manual"
vim.opt.foldlevelstart = 99
vim.opt.scrolloff = 2
vim.opt.wrap = true
vim.opt.signcolumn = "yes"
vim.opt.relativenumber = true
vim.opt.number = true
-- more is annoying as it takes too much space
-- less is not recommended given that most of the files might contain > 100 lines
vim.opt.numberwidth = 3
vim.opt.fillchars = { eob = " " }
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.undofile = true
vim.opt.wildmode = "list:longest"
vim.opt.wildignore = ".hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site"
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.vb = true
vim.opt.diffopt:append("iwhite")
vim.opt.diffopt:append("algorithm:histogram")
vim.opt.diffopt:append("indent-heuristic")
vim.opt.colorcolumn = "80"
vim.api.nvim_create_autocmd("Filetype", { pattern = "rust", command = "set colorcolumn=100" })
-- vim.api.nvim_create_autocmd("Filetype", { pattern = "python", command = "set colorcolumn=112" })
vim.opt.listchars = "tab:^ ,nbsp:¬,extends:»,precedes:«,trail:█,space:·"
vim.opt.list = false
-- disable format-on-save from `ziglang/zig.vim`
vim.g.zig_fmt_parse_errors = 0
vim.g.zig_fmt_autosave = 0
-- disable some unused providers failing when `:checkhealth`
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
-- quick-open
vim.keymap.set("", "<C-p>", "<cmd>Files<cr>")
-- search buffers
vim.keymap.set("n", "<leader>;", "<cmd>Buffers<cr>")
-- quick-save
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>")
-- make missing : less annoying
vim.keymap.set("n", ";", ":")
-- Ctrl+j as Esc (ideal to stay within the home row and save left pinkie)
vim.keymap.set("n", "<C-j>", "<Esc>")
vim.keymap.set("i", "<C-j>", "<Esc>")
vim.keymap.set("v", "<C-j>", "<Esc>")
vim.keymap.set("s", "<C-j>", "<Esc>")
vim.keymap.set("x", "<C-j>", "<Esc>")
vim.keymap.set("c", "<C-j>", "<Esc>")
vim.keymap.set("o", "<C-j>", "<Esc>")
vim.keymap.set("l", "<C-j>", "<Esc>")
vim.keymap.set("t", "<C-j>", "<Esc>")
-- Ctrl+k as Esc (ideal to stay within the home row and save left pinkie)
vim.keymap.set("n", "<C-k>", "<Esc>")
vim.keymap.set("i", "<C-k>", "<Esc>")
vim.keymap.set("v", "<C-k>", "<Esc>")
vim.keymap.set("s", "<C-k>", "<Esc>")
vim.keymap.set("x", "<C-k>", "<Esc>")
vim.keymap.set("c", "<C-k>", "<Esc>")
vim.keymap.set("o", "<C-k>", "<Esc>")
vim.keymap.set("l", "<C-k>", "<Esc>")
vim.keymap.set("t", "<C-k>", "<Esc>")
-- Ctrl+h to stop searching
vim.keymap.set("v", "<C-h>", "<cmd>nohlsearch<cr>")
vim.keymap.set("n", "<C-h>", "<cmd>nohlsearch<cr>")
-- Jump to start and end of line using the home row keys
vim.keymap.set("", "H", "^")
vim.keymap.set("", "L", "$")
-- TODO: not really working as expected, still need to investigate a better copy-paste
-- that works well with MacOS system
-- Neat X clipboard integration
-- <leader>p will paste clipboard into buffer
-- <leader>c will copy entire buffer into clipboard
-- vim.keymap.set('n', '<leader>p', '<cmd>read !wl-paste<cr>')
-- vim.keymap.set('n', '<leader>c', '<cmd>w !wl-copy<cr><cr>')
vim.keymap.set("v", "<leader>y", ":w !wl-copy<cr><cr>")
-- <leader>, shows/hides hidden characters
vim.keymap.set("n", "<leader>,", ":set invlist<cr>")
-- always center search results
vim.keymap.set("n", "n", "nzz", { silent = true })
vim.keymap.set("n", "N", "Nzz", { silent = true })
vim.keymap.set("n", "*", "*zz", { silent = true })
vim.keymap.set("n", "#", "#zz", { silent = true })
vim.keymap.set("n", "g*", "g*zz", { silent = true })
-- "very magic" (less escaping needed) regexes by default
vim.keymap.set("n", "?", "?\\v")
vim.keymap.set("n", "/", "/\\v")
vim.keymap.set("c", "%s/", "%sm/")
-- open new file adjacent to current file
vim.keymap.set("n", "<leader>o", ':e <C-R>=expand("%:p:h") . "/" <cr>')
-- no arrow keys --- force yourself to use the home row
vim.keymap.set("n", "<up>", "<nop>")
vim.keymap.set("n", "<down>", "<nop>")
vim.keymap.set("i", "<up>", "<nop>")
vim.keymap.set("i", "<down>", "<nop>")
vim.keymap.set("i", "<left>", "<nop>")
vim.keymap.set("i", "<right>", "<nop>")
-- window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
-- buffer navigation
vim.keymap.set("n", "<S-h>", ":bp<CR>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", ":bn<CR>", { desc = "Next buffer" })
-- use arrow keys for buffer navigation
vim.keymap.set("n", "<left>", ":bp<CR>", { desc = "Prev buffer" })
vim.keymap.set("n", "<right>", ":bn<CR>", { desc = "Next buffer" })
-- let the left and right arrows be useful: they can switch buffers
vim.keymap.set("n", "<left>", ":bp<cr>")
vim.keymap.set("n", "<right>", ":bn<cr>")
-- make j and k move by visual line, not actual line, when text is soft-wrapped
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
-- handy keymap for replacing up to next _ (like in variable names)
vim.keymap.set("n", "<leader>m", "ct_")
-- open lazygit
vim.keymap.set("n", "<leader>gg", "<cmd>:LazyGit<CR>", { silent = true })

-- make sure to disable the semantic tokens within the rust analyzer
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client then
      if client.name == "rust_analyzer" then
        client.server_capabilities.semanticTokensProvider = nil
      end
    end
  end,
})
-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  command = "silent! lua vim.hl.on_yank({ timeout = 500 })",
})
-- jump to last edit position on opening file
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function(_)
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
      -- except for in git commit messages
      -- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
      if not vim.fn.expand("%:p"):find(".git", 1, true) then
        vim.cmd('exe "normal! g\'\\""')
      end
    end
  end,
})
-- prevent accidental writes to buffers that shouldn't be edited
vim.api.nvim_create_autocmd("BufRead", { pattern = "*.orig", command = "set readonly" })
vim.api.nvim_create_autocmd("BufRead", { pattern = "*.pacnew", command = "set readonly" })
-- leave paste mode when leaving insert mode (if it was on)
vim.api.nvim_create_autocmd("InsertLeave", { pattern = "*", command = "set nopaste" })
-- set dockerfile filetype for files starting with "Dockerfile"
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "Dockerfile*",
  command = "set filetype=dockerfile",
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "rust", "dockerfile", "zig", "c", "sh", "python", "toml", "json", "yaml", "markdown" },
  callback = function()
    -- enable whitespace visualization (spaces as dots) for specific file types
    vim.opt_local.list = true
    -- highlight trailing whitespace as red blocks for specific file types only
    vim.schedule(function()
      vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "#f43841", fg = "#f43841" })
      vim.fn.matchadd('TrailingWhitespace', [[\s\+$]], 120)
    end)
  end,
})
-- Exclude LSP hover windows from trailing whitespace highlighting
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lspinfo", "help" },
  callback = function()
    vim.fn.clearmatches()
  end,
})
-- handle files without filetype (plain text files like config files)
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    -- Only apply to files with no filetype or text filetype
    if vim.bo.filetype == "" or vim.bo.filetype == "text" then
      vim.fn.matchadd('TrailingWhitespace', [[\s\+$]])
    end
  end,
})
local text = vim.api.nvim_create_augroup("text", { clear = true })
vim.api.nvim_create_autocmd("Filetype", {
  pattern = { "text", "markdown", "gitcommit" },
  group = text,
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.textwidth = 0
    vim.opt_local.colorcolumn = "80"
    vim.opt_local.spell = true
  end,
})
--- set line length limit for Python files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.colorcolumn = "113"
    vim.opt_local.textwidth = 0 -- Disable automatic line breaks
    vim.opt_local.foldmethod = "manual"
    -- Only enable line breaks for comments
    vim.opt_local.formatoptions = vim.opt_local.formatoptions
        - "t"                     -- Disable auto-wrapping of text
        + "c"                     -- Allow wrapping of comments
        + "q"                     -- Allow formatting of comments with gq
    vim.bo.commentstring = "# %s" -- Space after pound sign
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "rust", "ts" },
  callback = function()
    vim.bo.commentstring = "// %s" -- Space after double slash
  end
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "sh",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
  end,
})
--- update lua settings to use an indent size of 2 spaces instead
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.tabstop = 2
  end
})
--- set autoformatting on file save with default auto-formatter
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.rs", "*.lua", "Dockerfile*", "*.yaml" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
--- set autoformatting on file save for bash with shfmt
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.sh",
  callback = function()
    -- Save cursor position
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    -- Format buffer with shfmt, 4 space indentation
    vim.cmd("%!shfmt -i 4")
    -- Optionally restore cursor position (improves UX)
    pcall(vim.api.nvim_win_set_cursor, 0, { row, col })
  end,
})
--- set autoformatting on file save for zig
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.zig", "*.zon" },
  callback = function(_)
    vim.lsp.buf.code_action({
      context = { diagnostics = {}, only = { "source.fixAll" } },
      apply = true,
    })
  end
})
--- set autoformatting on file save for json with jq
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.json",
  callback = function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.cmd("%!jq --indent 2 .")
    pcall(vim.api.nvim_win_set_cursor, 0, { row, col })
  end,
})
--- create directory when creating file (if not created already)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    ---@diagnostic disable-next-line: undefined-field
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- first, grab the manager
-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- then, setup!
require("lazy").setup({
  -- disable luarocks i.e., rockspec
  rocks = { enabled = false },
  -- main color scheme
  {
    "blazkowolf/gruber-darker.nvim",
    lazy = false,    -- load at start
    priority = 1000, -- load first
    config = function()
      require("gruber-darker").setup({
        opts = {
          bold = false,
          italic = {
            strings = false,
          },
        },
      })
      vim.o.background = "dark"
      vim.cmd([[colorscheme gruber-darker]])
      vim.api.nvim_set_hl(0, "Whitespace", { fg = "#2a2a2a", blend = 95 }) -- Extremely subtle for normal spaces
      vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "#f43841" })     -- Red background for trailing spaces
      -- Enable cursorline for CursorLineNr highlighting to work
      vim.opt.cursorline = true
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffdd33" }) -- Yellow for current line number
    end,
  },
  -- previously I was using this but let's try now with gruber-hard instead
  -- {
  --     "tinted-theming/tinted-vim",
  --     lazy = false,    -- load at start
  --     priority = 1000, -- load first
  --     config = function()
  --         vim.cmd([[colorscheme base16-gruvbox-dark-hard]])
  --         vim.o.background = "dark"
  --         -- Make comments more prominent -- they are important.
  --         local bools = vim.api.nvim_get_hl(0, { name = "Boolean" })
  --         vim.api.nvim_set_hl(0, "Comment", bools)
  --         -- Make it clearly visible which argument we're at.
  --         local marked = vim.api.nvim_get_hl(0, { name = "PMenu" })
  --         vim.api.nvim_set_hl(
  --             0,
  --             "LspSignatureActiveParameter",
  --             { fg = marked.fg, bg = marked.bg, ctermfg = marked.ctermfg, ctermbg = marked.ctermbg, bold = true }
  --         )
  --     end,
  -- },
  -- lazygit
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      vim.g.lazygit_config_file_path = vim.fn.expand("~/.config/lazygit/config.yaml")
    end,
  },
  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          disable_devicons = true,
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            -- Leaving this here commented, as I use might switch to it from time to time
            -- "--case-sensitive",
            "--hidden",
            "--glob",
            "!**/.git/*",
            "--glob",
            "!**/.venv/*",
          },
        },
        pickers = {
          find_files = {
            find_command = {
              "rg",
              "--files",
              "--hidden",
              "--glob",
              "!**/.git/*",
              "--glob",
              "!**/.venv/*",
            },
          },
          live_grep = {
            additional_args = function()
              return { "--hidden", "--glob", "!**/.git/*" }
            end,
          },
        },
      })
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader><leader>", builtin.find_files)
      vim.keymap.set("n", "<leader>/", builtin.live_grep)
    end,
  },
  -- neotree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- disable the freaking ugly nerd icons
      -- "nvim-tree/nvim-web-devicons",
      -- only the icon for the directories is kept (not ideal but meh)
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          follow_current_file = {
            enabled = true,
          },
          hijack_netrw_behavior = "open_default",
        },
      })
      vim.keymap.set("n", "<leader>fe", "<cmd>Neotree toggle<cr>", { desc = "Toggle Explorer" })
      -- vim.keymap.set("n", "<leader>e", "<cmd>Neotree focus<cr>", { desc = "Focus Explorer" })
    end,
  },
  -- spectre
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("spectre").setup({
        -- https://github.com/nvim-pack/nvim-spectre/issues/118#issuecomment-1531683211
        -- replace_engine = {
        --   ["sed"] = {
        --     cmd = "sed",
        --     args = {
        --       "-i",
        --       "",  -- Empty string for no backup (mandatory on BSD sed)
        --       "-E" -- Extended regex for capture groups
        --     },
        --   },
        -- },
        -- default = {
        --   replace = {
        --     cmd_esc = [[\\\\\()%[%]^$@/.*~&|]], -- Escape special chars
        --     options = "C"
        --   }
        -- }
        replace_engine = {
          ["sd"] = {
            cmd = "sd",
            args = {},
          },
        },
        default = {
          replace = {
            cmd = "sd",
          },
        },
      })
      vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").open()<CR>', { desc = "Open Spectre" })
      vim.keymap.set(
        "n",
        "<leader>sw",
        '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
        { desc = "Search current word" }
      )
      vim.keymap.set(
        "v",
        "<leader>sw",
        '<esc><cmd>lua require("spectre").open_visual()<CR>',
        { desc = "Search current word" }
      )
      vim.keymap.set(
        "n",
        "<leader>sp",
        '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
        { desc = "Search on current file" }
      )
    end,
  },
  -- nice bar at the bottom
  {
    "itchyny/lightline.vim",
    lazy = false, -- also load at start since it's UI
    config = function()
      -- no need to also show mode in cmd line when we have bar
      vim.o.showmode = false
      -- NOTE: yes, `vim.o.cmdheight = 0` is minimal, but given that it hides the
      -- output of commands as e.g. `:w` it makes it really annoying as `nvim` displays
      -- the message for the user to ack to avoid missing critical information
      vim.o.cmdheight = 1
      -- ensure status line is always shown and at bottom
      vim.o.laststatus = 3
      vim.g.lightline = {
        active = {
          left = {
            { "mode",     "paste" },
            { "readonly", "filename", "modified" },
          },
          right = {
            { "lineinfo" },
            { "percent" },
            { "fileencoding", "filetype" },
          },
        },
        component_function = {
          filename = "LightlineFilename",
        },
      }
      function LightlineFilenameInLua(_)
        if vim.fn.expand("%:t") == "" then
          return "[No Name]"
        else
          return vim.fn.getreg("%")
        end
      end

      vim.api.nvim_exec2(
        [[
    function! g:LightlineFilename()
      return v:lua.LightlineFilenameInLua()
    endfunction
  ]],
        { output = false }
      )
    end,
  },
  -- quick navigation
  {
    "ggandor/leap.nvim",
    config = function()
      local leap = require("leap")
      leap.opts.safe_labels = {}
      -- Create custom mappings to avoid conflicts
      vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap-forward)')
      vim.keymap.set({ 'n', 'x', 'o' }, 'gs', '<Plug>(leap-backward)')
      vim.keymap.set({ 'n', 'x', 'o' }, 'gz', '<Plug>(leap-from-window)')
    end,
  },
  -- better %
  {
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      vim.g.matchup_surround_enabled = 0
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_hi_surround_always = 0
    end,
  },
  -- auto-cd to root of git project
  -- 'airblade/vim-rooter'
  {
    "notjedi/nvim-rooter.lua",
    config = function()
      require("nvim-rooter").setup()
    end,
  },
  -- required for `helm-ls`
  -- https://github.com/mrjosh/helm-ls/blob/0c3d346843e36e106ff263c071e638f956966c91/examples/nvim/init.lua#L19-L21
  { "towolf/vim-helm", ft = "helm" },
  -- nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Zig language server
      vim.lsp.config.zls = {
        cmd = { 'zls' },
        filetypes = { 'zig', 'zir' },
        root_markers = { 'build.zig', '.git' },
        settings = {
          zls = {
            -- Further information about build-on save:
            -- https://zigtools.org/zls/guides/build-on-save/
            -- enable_build_on_save = true,
          }
        }
      }
      vim.lsp.enable('zls')

      -- you may never seen me actually coding in ts, but let's keep it here
      -- because I may eventually need it here and there
      vim.lsp.config.ts_ls = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
        root_markers = { "package.json", "tsconfig.json", ".git" },
        on_attach = function(_, bufnr)
          -- disable ts_ls's formatting if you use another tool like prettier.
          -- client.server_capabilities.documentFormattingProvider = false

          -- create an autocmd group and set up formatting on save for the current buffer.
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end,
      }
      vim.lsp.enable('ts_ls')

      -- Docker language server
      vim.lsp.config.dockerls = {
        cmd = { "docker-langserver", "--stdio" },
        filetypes = { "dockerfile" },
        root_markers = { "Dockerfile", ".git" },
        on_attach = function(client, _)
          -- Enable formatting
          client.server_capabilities.documentFormattingProvider = true
        end,
      }
      vim.lsp.enable('dockerls')

      -- -- YAML language server
      -- TODO: at the moment all the default LSPs are disabled, but this should
      -- be fixed, whilst still making Helm work? At the moment the basic Helm
      -- support is just fine
      -- lspconfig.yamlls.setup({
      --     settings = {
      --         yaml = {
      --             schemas = {
      --                 -- ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      --                 -- ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
      --                 -- ["https://raw.githubusercontent.com/kubernetes/kubernetes/master/api/openapi-spec/swagger.json"] = "{deployment,service,ingress,configmap,secret,statefulset,daemonset,job,cronjob}.{yaml,yml}",
      --                 kubernetes = "templates/**",
      --             },
      --             format = {
      --                 enable = true,
      --             },
      --             validate = true,
      --             completion = true,
      --         },
      --     },
      -- })

      -- helm support (?)
      vim.lsp.config.helm_ls = {
        cmd = { "helm_ls", "serve" },
        filetypes = { "helm" },
        root_markers = { "Chart.yaml", ".git" },
        settings = {
          ["helm-ls"] = {
            yamlls = {
              path = "yaml-language-server",
            }
          }
        }
      }
      vim.lsp.enable('helm_ls')

      vim.lsp.config.yamlls = {
        cmd = { "yaml-language-server", "--stdio" },
        filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
        root_markers = { ".git" },
      }
      vim.lsp.enable('yamlls')

      -- lua lsp
      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
        on_init = function(client)
          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT"
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
              }
              -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
              -- library = vim.api.nvim_get_runtime_file("", true)
            }
          })
        end,
        settings = {
          Lua = {
            format = {
              enable = true,
              defaultConfig = {
                indent_style = "Spaces",
                indent_size = "2",
              }
            },
            -- hint = { enable = false },
            -- codeLens = { enable = false },
            -- completion = { enable = false },
            -- diagnostics = { enable = false }
          }
        }
      }
      vim.lsp.enable('lua_ls')

      -- PyRight LSP
      vim.lsp.config.pyright = {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
      }
      vim.lsp.enable('pyright')

      -- Ruff LSP
      vim.lsp.config.ruff = {
        cmd = { "ruff", "server", "--preview" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
        on_attach = function(client, bufnr)
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false

          -- Enable formatting on save
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                async = false,
                name = "ruff"
              })
              vim.lsp.buf.code_action({
                context = { diagnostics = {}, only = { "source.organizeImports" } },
                apply = true,
              })
            end,
          })
        end,
        settings = {
          ruff = {
            organizeImports = true,
          },
        },
        capabilities = {
          general = {
            positionEncodings = { "utf-16" }
          },
        }
      }
      vim.lsp.enable('ruff')

      -- Rust
      vim.lsp.config.rust_analyzer = {
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
        root_markers = { "Cargo.toml", "rust-project.json", ".git" },
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
            },
            imports = {
              group = {
                enable = false,
              },
            },
            completion = {
              postfix = {
                enable = false,
              },
            },
          },
        },
      }
      vim.lsp.enable('rust_analyzer')

      -- Bash LSP
      vim.lsp.config.bashls = {
        cmd = { "bash-language-server", "start" },
        filetypes = { "sh" },
        root_markers = { ".git" },
        settings = {
          bashIde = {
            shellcheckPath = "",
          },
        },
      }
      vim.lsp.enable('bashls')

      -- -- C language server (clangd)
      -- lspconfig.clangd.setup({
      --   filetypes = { "c", "cpp", "objc", "objcpp" },
      --   cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
      --   on_attach = function(client, _)
      --     -- Disable formatting capabilities to prevent auto-formatting
      --     client.server_capabilities.documentFormattingProvider = false
      --     client.server_capabilities.documentRangeFormattingProvider = false
      --   end,
      --   capabilities = {
      --     offsetEncoding = { "utf-16" },
      --   },
      -- })

      -- Global mappings.
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
      vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end)
      vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end)
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

      -- apply code actions if any
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings.
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          -- Add M binding for man pages in C files
          if vim.bo.filetype == "c" then
            vim.keymap.set("n", "M", function()
              local word = vim.fn.expand("<cword>")
              vim.cmd("Man " .. word)
            end, opts)
          end
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)

          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
      })
    end,
  },
  -- LSP-based code-completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/vim-vsnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
        }, {
          { name = "path" },
        }),
        experimental = {
          ghost_text = true,
        },
      })

      cmp.setup.cmdline(":", {
        sources = cmp.config.sources({
          { name = "path" },
        }),
      })
    end,
  },
  -- mason.nvim
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "ruff",
        "pyright",
        -- `rustup component add rust-analyzer`
        "rust-analyzer",
        -- installed with Mason e.g. `:MasonInstall helm-ls`
        "bash-language-server",
        "yaml-language-server",
        "dockerfile-language-server",
        "helm-ls",
        "typescript-language-server",
        "lua-language-server",
        "shfmt",
        -- "clangd",
      },
      automatic_installation = true,
    },
    config = function(_, opts)
      require("mason").setup(opts)
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
      end, {})
    end,
  },
  -- inline function signatures
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, _)
      -- Get signatures (and _only_ signatures) when in argument lists.
      require("lsp_signature").setup({
        doc_lines = 0,
        handler_opts = {
          border = "none",
        },
      })
    end,
  },
  -- terraform
  {
    "hashivim/vim-terraform",
    ft = { "terraform" },
  },
  -- toml
  "cespare/vim-toml",
  -- yaml
  {
    "cuducos/yaml.nvim",
    ft = { "yaml" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  -- rust
  {
    "rust-lang/rust.vim",
    ft = { "rust" },
    config = function()
      vim.g.rustfmt_autosave = 1
      vim.g.rustfmt_emit_files = 1
      vim.g.rustfmt_fail_silently = 0
      vim.g.rust_clip_command = "wl-copy"
    end,
  },
  -- fish
  "khaveesh/vim-fish-syntax",
  -- markdown
  {
    "plasticboy/vim-markdown",
    ft = { "markdown" },
    dependencies = {
      "godlygeek/tabular",
    },
    config = function()
      -- never ever fold!
      vim.g.vim_markdown_folding_disabled = 0
      -- support front-matter in .md files
      vim.g.vim_markdown_frontmatter = 1
      -- 'o' on a list item should insert at same level
      vim.g.vim_markdown_new_list_item_indent = 0
      -- don't add bullets when wrapping:
      -- https://github.com/preservim/vim-markdown/issues/232
      vim.g.vim_markdown_auto_insert_bullets = 0
    end,
  },
  -- zen mode
  {
    "folke/zen-mode.nvim",
    opts = {
      plugins = {
        -- disable some global vim options (vim.o...)
        -- comment the lines to not apply the options
        options = {
          enabled = true,
          ruler = false,   -- disables the ruler text in the cmd line area
          showcmd = false, -- disables the command in the last line of the screen
          -- you may turn on/off statusline in zen mode by setting 'laststatus'
          -- statusline will be shown only if 'laststatus' == 3
          laststatus = 0, -- turn off the statusline in zen mode
        },
        -- this will change the font size on kitty when in zen mode
        -- to make this work, you need to set the following kitty options:
        -- - allow_remote_control socket-only
        -- - listen_on unix:/tmp/kitty
        -- kitty = {
        --   enabled = true,
        --   font = "+4", -- font size increment
        -- },
      },
    }
  },
  -- claude-code.nvim
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required for git operations
    },
    branch = "main",
    config = function()
      require("claude-code").setup({})
      vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<cr>", { desc = "Claude Code Command" })
    end,
  },
  -- (not stable) typr i.e. like a monkey type experience but on terminal
  -- {
  --   "nvzone/typr",
  --   dependencies = "nvzone/volt",
  --   opts = {},
  --   cmd = { "Typr", "TyprStats" },
  -- }
})
