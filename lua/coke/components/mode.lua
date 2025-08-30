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
function M:fmt(ctx)
	if not ctx.active then return "" end
	if vim.bo.bt == "help" then return "Help  " end
	if vim.bo.bt == "terminal" then return "t  " end
	return ctx.modes[M.mode].txt .. "  "
end

M.events.opts.callback({})

return M
