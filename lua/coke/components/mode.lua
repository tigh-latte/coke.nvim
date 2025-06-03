local M = {
	mode_map = {
		n = { txt = "N", fg = "#212121", bg = "#d7af87" },
		niI = { txt = "NI", bg = "#d7af87" },
		no = { txt = "no", bg = "#d7af87" },
		i = { txt = "I", fg = "#212121", bg = "#73b8f1" },
		R = { txt = "R", bg = "#af5f5a" },
		Rv = { txt = "Rv", bg = "#af5f5a" },
		ic = { txt = "IC", c = "C", bg = "#53892c" },
		c = { txt = "C", bg = "#53892c" },
		v = { txt = "V", bg = "#d19a66" },
		V = { txt = "V-LINE", bg = "#d19a66" },
		[""] = { txt = "V-BLOCK", fg = "#212121", bg = "#d19a66" },
		s = { txt = "S", fg = "#212121", bg = "#d19a66" },
		S = { txt = "S", bg = "#d19a66" },
		nt = { txt = "t", bg = "#53892c" },
		t = { txt = "t", bg = "#53892c" },
	},
}

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
	return ctx.hl_rev .. "" .. ctx.hl .. "  " .. M.mode_map[M.mode].txt .. "  " --.. ctx.hl_rev .. ""
end

function M.colour()
	local mode = M.mode_map[M.mode]
	return {
		fg = mode.fg or "#212121",
		bg = mode.bg,
		bold = true,
	}
end

M.events.opts.callback({})

return M
