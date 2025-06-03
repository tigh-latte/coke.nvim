---@class coke.Context
---@field hl string
---@field hl_rev string
---@field bufnr integer
---@field winnr integer
---@field active boolean
---@field modes coke.keymap.modes

---@class coke.EventHandler
---@field kind (string|string[])?
---@field opts (vim.api.keyset.create_autocmd|vim.api.keyset.create_autocmd[])?

---@class coke.Component
---@field fmt fun(coke.Context): string
---@field colour (vim.api.keyset.highlight|fun(coke.Context):vim.api.keyset.highlight)?
---@field events coke.EventHandler?

---@class coke.Components
---@field left coke.Component[]
---@field right coke.Component[]

---@class coke.Config
---@field enabled boolean?
---@field components coke.Components?
---@field modes coke.keymap.modes?

---@class coke.keymap.modes
---@field n coke.type.mode?
---@field niI coke.type.mode?
---@field no coke.type.mode?
---@field i coke.type.mode?
---@field ix coke.type.mode?
---@field R coke.type.mode?
---@field Rv coke.type.mode?
---@field ic coke.type.mode?
---@field c coke.type.mode?
---@field v coke.type.mode?
---@field V coke.type.mode?
---@field [""] coke.type.mode?
---@field s coke.type.mode?
---@field S coke.type.mode?
---@field nt coke.type.mode?
---@field t coke.type.mode?

---@class coke.type.mode
---@field txt? string
---@field hl (string|vim.api.keyset.highlight)?
