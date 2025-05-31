local M = {
}

M.event = {
	events = { "CursorMoved", "CursorMovedI" },
	fmt = function(ev)
		local line, row = unpack(vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win()))
		M.line, M.row = line, row + 1
	end,
}

function M.fmt()
	return "[" .. M.line .. ":" .. M.row .. "]"
end

M.event.fmt({})

return M
