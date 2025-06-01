---@class coke.EventHandler
---@field kind (string|string[])?
---@field opts (vim.api.keyset.create_autocmd|vim.api.keyset.create_autocmd[])?

---@class coke.Component
---@field fmt fun(): string
---@field colour (vim.api.keyset.highlight|fun():vim.api.keyset.highlight)?
---@field events coke.EventHandler?

---@class coke.Components
---@field left coke.Component[]
---@field right coke.Component[]

---@class coke.Config
---@field enabled boolean
---@field components coke.Components
