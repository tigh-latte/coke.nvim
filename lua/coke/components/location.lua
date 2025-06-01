local M = {}

M.events = {
	kind = { "CursorMoved", "CursorMovedI" },
	opts = {
		callback = function(ev)
			local line, row = unpack(vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win()))
			M.line, M.row = line, row + 1
		end,
	},
}

function M.fmt()
	return "%p%% [" .. M.line .. ":" .. M.row .. "]"
end

M.events.opts.callback({})

return M
