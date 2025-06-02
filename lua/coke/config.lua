---@class coke.Context
---@field hl string
---@field hl_rev string
---@field bufnr integer
---@field winnr integer
---@field active boolean

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
---@field enabled boolean
---@field components coke.Components
