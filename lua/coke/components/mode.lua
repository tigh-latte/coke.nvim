local M = {
	mode_map = {
		n = { txt = "N", fg = "#262626", bg = "#dfff00" },
		niI = { txt = "NI", fg = "", bg = "#dfff00" },
		no = { txt = "no", fg = "", bg = "#dfff00" },
		i = { txt = "I", fg = "#262626", bg = "#00dfff" },
		R = { txt = "R", fg = "", bg = "#af0000" },
		Rv = { txt = "Rv", fg = "", bg = "#af0000" },
		ic = { txt = "IC", c = "C", fg = "", bg = "#00d700" },
		c = { txt = "C", fg = "", bg = "#00d700" },
		v = { txt = "V", fg = "", bg = "#ffaf00" },
		V = { txt = "V-LINE", fg = "", bg = "#ffaf00" },
		[""] = { txt = "V-Block", fg = "#262626", bg = "#ffaf00" },
		s = { txt = "S", fg = "#262626", bg = "#ffaf00" },
		S = { txt = "S", fg = "", bg = "#ffaf00" },
		nt = { txt = "T", fg = "", bg = "#00d700" },
		t = { txt = "T", fg = "", bg = "#00d700" },
	},
}

M.event = {
	events = "ModeChanged",
	fmt = function(ev)
		M.mode = vim.api.nvim_get_mode().mode
	end,
}

function M.fmt()
	return " " .. M.mode_map[M.mode].txt .. " "
end

function M.colour()
	local mode = M.mode_map[M.mode]
	return {
		fg = mode.fg,
		bg = mode.bg,
		bold = true,
	}
end

M.event.fmt({})

return M
