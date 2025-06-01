local M = {
	mode_map = {
		n = { txt = "N", fg = "#262626", bg = "#d7af87" },
		niI = { txt = "NI", bg = "#d7af87" },
		no = { txt = "no", bg = "#d7af87" },
		i = { txt = "I", fg = "#262626", bg = "#5fafaf" },
		R = { txt = "R", bg = "#af5f5a" },
		Rv = { txt = "Rv", bg = "#af5f5a" },
		ic = { txt = "IC", c = "C", bg = "#53892c" },
		c = { txt = "C", bg = "#53892c" },
		v = { txt = "V", bg = "#d19a66" },
		V = { txt = "V-LINE", bg = "#d19a66" },
		[""] = { txt = "V-Block", fg = "#262626", bg = "#d19a66" },
		s = { txt = "S", fg = "#262626", bg = "#d19a66" },
		S = { txt = "S", bg = "#d19a66" },
		nt = { txt = "T", bg = "#53892c" },
		t = { txt = "T", bg = "#53892c" },
	},
}

M.events = {
	kind = { "ModeChanged" },
	opts = {
		callback = function(ev)
			M.mode = vim.api.nvim_get_mode().mode
		end,
	},
}

function M.fmt()
	return " " .. M.mode_map[M.mode].txt .. " "
end

function M.colour()
	local mode = M.mode_map[M.mode]
	return {
		fg = mode.fg or "#262626",
		bg = mode.bg,
		bold = true,
	}
end

M.events.opts.callback({})

return M
