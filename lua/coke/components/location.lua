local M = {
	cur_line = 0,
	cur_row = 0,
	total_lines = 0,
	mode_map = {
		n = { fg = "#212121", bg = "#d7af87" },
		niI = { bg = "#d7af87" },
		no = { bg = "#d7af87" },
		i = { fg = "#212121", bg = "#5fafaf" },
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

M.events = {
	kind = { "CursorMoved", "CursorMovedI" },
	opts = {
		callback = function(ev)
			local line, row = unpack(vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win()))
			M.cur_line, M.cur_row, M.total_lines = line, row + 1, vim.api.nvim_buf_line_count(0)
		end,
	},
}

function M.fmt(ctx)
	local output = " %p%% %l/" .. M.total_lines .. ":" .. M.cur_row .. " "
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

M.events.opts.callback({})

return M
