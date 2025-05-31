---@class coke.EventHandler
---@field events string|string[]
---@field fmt fun(ev: vim.api.keyset.create_autocmd.callback_args): boolean?

---@class coke.Component
---@field fmt fun(): string
---@field colour vim.api.keyset.highlight|fun():vim.api.keyset.highlight
---@field event coke.EventHandler?

---@class coke.Components
---@field left coke.Component[]
---@field right coke.Component[]

---@class coke.Config
---@field enabled boolean
---@field components coke.Components
