local M = {}

M.events = { {
	kind = { "DirChanged" },
	opts = {
		callback = function(ev)
			M.cwd = ev.file
		end,
	},
}, {
	kind = { "BufModifiedSet" },
	opts = {
		callback = function() end,
	},
} }

function M:fmt(ctx)
	local fname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(ctx.winnr))

	if vim.startswith(fname, M.cwd) then
		return " %<" .. fname:sub(#M.cwd + 2, #fname) .. "%m%r%h "
	end

	return " %<%f%m%r%h "
end

function M.colour()
	if vim.bo.modified then
		return { fg = "#c678dd" }
	end
	return "%*"
end

M.cwd = vim.uv.cwd()

return M
