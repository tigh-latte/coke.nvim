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
	if vim.bo.bt == "terminal" then
		local parts = vim.split(vim.fn.expand("%"), ":")
		return " %<" .. parts[#parts]
	elseif vim.bo.bt == "help" then
		return " %<%f "
	end
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
