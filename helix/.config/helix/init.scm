(require "helix/configuration.scm")

(require "vim-hx/init.scm")

;; Activate Vim keybinding emulation
(set-vim-keybindings!)

;; oil.hx — directory-as-buffer file manager, like Oil.nvim
(require "oil/oil.scm")
