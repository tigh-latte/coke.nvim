local M = {}

M.events = {
	kind = { "ModeChanged" },
	opts = {
		callback = function(_)
			M.mode = vim.api.nvim_get_mode().mode
		end,
	},
}
---@param ctx coke.Context
---@return string
function M.fmt(ctx)
	if not ctx.active then return "" end
	return ctx.hl_rev .. "" .. ctx.hl .. "  " .. ctx.modes[M.mode].txt .. "  " --.. ctx.hl_rev .. ""
end

M.events.opts.callback({})

return M
