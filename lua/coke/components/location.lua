local M = {
	mode_map = {
		n = { fg = "#212121", bg = "#d7af87" },
		niI = { bg = "#d7af87" },
		no = { bg = "#d7af87" },
		i = { fg = "#212121", bg = "#73b8f1" },
		R = { bg = "#af5f5a" },
		Rv = { bg = "#af5f5a" },
		ic = { c = "C", bg = "#53892c" },
		c = { bg = "#53892c" },
		v = { bg = "#d19a66" },
		V = { bg = "#d19a66" },
		[""] = { fg = "#212121", bg = "#d19a66" },
		s = { fg = "#212121", bg = "#d19a66" },
		S = { bg = "#d19a66" },
		nt = { bg = "#53892c" },
		t = { bg = "#53892c" },
	},
}

function M.fmt(ctx)
	local output = " %p%% %l/%L:%c "
	if ctx.active then
		return output .. ctx.hl_rev .. ""
	end
	return output .. " "
end

function M.colour(ctx)
	if not ctx.active then return nil end
	return {
		fg = "#212121",
		bg = M.mode_map[vim.api.nvim_get_mode().mode].bg,
	}
end

return M
