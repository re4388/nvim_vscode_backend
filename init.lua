-- print('lua start finished ')


-- lazy nvim bootstrap
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)



require('lazy').setup({
  -- 'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- https://github.com/numToStr/Comment.nvim
  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
    },
    lazy = false,
  },


  {
    "chrisgrieser/nvim-various-textobjs",
    lazy = false,
    opts = {
      -- use suggested keymaps (see overview table in README)
      useDefaultKeymaps = false,
      -- display notifications if a text object is not found
      notifyNotFound = true,
    },
  },

  -- to create your own text oject
  -- { "kana/vim-textobj-user" },
  -- { "beloglazov/vim-textobj-quotes" },
  -- { "kana/vim-textobj-entire" },
  -- { "Julian/vim-textobj-brace" },
  -- { "tpope/vim-commentary" },
  { "tpope/vim-repeat" },


  -- {
  --   "vim-scripts/ReplaceWithRegister",
  --   config = function()
  --   end
  -- },


  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },


  -- https://github.com/gbprod/substitute.nvim
  {
    "gbprod/substitute.nvim",
    opts = {
      on_substitute = nil,
      yank_substituted_text = false,
      preserve_cursor_position = false,
      modifiers = nil,
      highlight_substituted_text = {
        enabled = true,
        timer = 500,
      },
      range = {
        prefix = "s",
        prompt_current_text = false,
        confirm = false,
        complete_word = false,
        subject = nil,
        range = nil,
        suffix = "",
        auto_apply = false,
        cursor_position = "end",
      },
      exchange = {
        motion = false,
        use_esc_to_cancel = true,
        preserve_cursor_position = false,
      },
    }
  }


}, {
})

-- https://github.com/gbprod/substitute.nvim
vim.keymap.set("n", "s", require('substitute').operator, { noremap = true })
vim.keymap.set("n", "ss", require('substitute').line, { noremap = true })
vim.keymap.set("n", "S", require('substitute').eol, { noremap = true })
vim.keymap.set("x", "s", require('substitute').visual, { noremap = true })


-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
-- vim.g.mapleader = ' '
-- vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
-- vim.g.have_nerd_font = false

-- [[ Setting options ]]
-- require 'lua.options'

-- copy into system cliboard
vim.opt.clipboard = 'unnamedplus'




-- https://stackoverflow.com/a/2288438
-- with below setting, you can search with case sensitive if you have capital letter in search query
-- example:
-- /copyright      " Case insensitive
-- /Copyright      " Case sensitive
-- /copyright\C    " Case sensitive
-- /Copyright\c    " Case insensitive
vim.opt.ignorecase = true
vim.opt.smartcase = true


-- [[ Basic Keymaps ]]
-- require 'lua.keymaps'
-- vim.opt.hlsearch = true
-- vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

--------------------------------- various-textobjs ------------------------------------

-- anyQuote: between any unescaped1 ", ', or ` in a line
vim.keymap.set({ "o", "x" }, "aq", '<cmd>lua require("various-textobjs").anyQuote("outer")<CR>')
vim.keymap.set({ "o", "x" }, "iq", '<cmd>lua require("various-textobjs").anyQuote("inner")<CR>')

-- anyBracket: between any (), [], or {} in a line
-- vim.keymap.set({ "o", "x" }, "aj", '<cmd>lua require("various-textobjs").anyBracket("outer")<CR>')
-- vim.keymap.set({ "o", "x" }, "ij", '<cmd>lua require("various-texuutobjs").anyBracket("inner")<CR>')

-- entireBuffer entire buffer as one text objwhat is the difference between ect
vim.keymap.set({ "o", "x" }, "ie", "<cmd>lua require('various-textobjs').entireBuffer()<CR>")


--number
vim.keymap.set({ "o", "x" }, "an", "<cmd>lua require('various-textobjs').number('inner')<CR>")
vim.keymap.set({ "o", "x" }, "in", "<cmd>lua require('various-textobjs').number('outer')<CR>")


-- 修改本來的熱鍵，會讓你的肌肉記憶無法轉移，不建議
-- vim.keymap.set("n", "v", "V", { noremap = true })
-- vim.keymap.set("n", "V", "v", { noremap = true })
--
-- make text object easier to type
vim.keymap.set("o", "ar", "a]") -- [r]ectangular bracket
vim.keymap.set("o", "ir", "i]") -- [r]ectangular bracket

-- 可能沒必要，大 B 就可以取代
-- vim.keymap.set("o", "ac", "a}") -- [c]urly brace
-- vim.keymap.set("o", "ic", "i}") -- [c]urly brace

-- 這個 ap, ip 會跟 paragraph 衝到
-- 這個好像沒必要， 小 b 就有一樣的效果
-- vim.keymap.set("o", "at", "a)") -- paren[t]heses
-- vim.keymap.set("o", "it", "i)") -- paren[t]heses


-- f to parenthese, curly brace and rectangular bracket
-- F to parenthese, curly brace and rectangular bracket
-- t to parenthese, curly brace and rectangular bracket
-- T to parenthese, curly brace and rectangular bracket
-- 以上無法設定熱鍵，因為會r, b p 等等本身也是可以跳過去的 XD
------------------------------------------------------------------------------------------

-- let's make life easier
vim.api.nvim_set_keymap('n', 'qq', 'yiw', { noremap = true })
-- r as replace
-- vim.api.nvim_set_keymap('n', 'qr', 'griw', { noremap = false })

-- qs to copy string quicker
vim.api.nvim_set_keymap('n', 'qs', 'yiq', { noremap = false })


-- quick move
vim.api.nvim_set_keymap('n', 'qj', '20gj', { noremap = true })
vim.api.nvim_set_keymap('n', 'qk', '20gk', { noremap = true })
vim.api.nvim_set_keymap('v', 'qj', '20gj', { noremap = true })
vim.api.nvim_set_keymap('v', 'qk', '20gk', { noremap = true })

-- surround vim or other
vim.api.nvim_set_keymap('n', "q'", "ysiw'", { noremap = true })
vim.api.nvim_set_keymap('n', 'q"', 'ysiw"', { noremap = true })
vim.api.nvim_set_keymap('n', 'q`', 'ysiw`', { noremap = true })
vim.api.nvim_set_keymap('n', 'qb', 'ysiwb', { noremap = true })
vim.api.nvim_set_keymap('n', 'qB', 'ysiwB', { noremap = true })
vim.api.nvim_set_keymap('n', 'qt', 'ysiw<', { noremap = true })
vim.api.nvim_set_keymap('n', 'q[', 'ysiw[', { noremap = true })
vim.api.nvim_set_keymap('n', 'q*', 'ysiw', { noremap = true })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
-- require 'lua.lazy-bootstrap'

-- [[ Configure and install plugins ]]
-- require 'lua.lazy-plugins'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et




-- https://github.com/numToStr/Comment.nvim?tab=readme-ov-file#%EF%B8%8F-filetypes--languages
-- to support .json comment (whiih is not supported by default)
local ft = require("Comment.ft")
ft.json = { '//%s', '/*%s*/' }


-- print('lua load finished ')
