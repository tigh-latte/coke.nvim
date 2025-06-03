## Coke

My kind of line.

### Overview

Another plugin built by me, for me, that you shouldn't use.

Originally, for years, I used [`airline`](https://github.com/vim-airline/vim-airline), and while it always worked well for me out of the box, it was written in vimscript (which I refuse to learn) and therefor, left me unable to extend it.

So, I finally decided to bite the bullet and switched to [`lualine`](https://github.com/nvim-lualine/lualine.nvim). While nice, I noticed there was a lag when it was updating itself, and after a quick read its codebase, turns out it updates by polling on a timer. Not happy, I figured why not just write my own.

### Features

1. Extensible, you can just write your own component and drop it in (docs may come).
1. Event driven, so updates happen as fast as neovim can fire them.
1. Fugitive integration, to shout at you if you're editing on `main`.
1. LSP errors and warnings, driven from diagnostic events.

### Installation

Using [lazy](https://github.com/folke/lazy.nvim.git):

```lua
{
    "tigh-latte/coke.nvim",
    depedencies = { "tpope/vim-fugitive" }, -- a dependency until I make it optional.
}
```

### Options

To do.

### Things I would like to do

- [ ] Add screenshots to this repo
- [ ] Add a sane default colour scheme (which isn't the one I use)
- [ ] Make the config api a touch easier
