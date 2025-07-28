local M = {}

M.events = {
	kind = "DirChanged",
	opts = {
		callback = function(ev)
			M.cwd = ev.file
		end,
	},
}

function M:fmt(ctx)
	local fname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(ctx.winnr))

	if vim.startswith(fname, M.cwd) then
		return " " .. fname:sub(#M.cwd + 2, #fname) .. "%m%r%h "
	end

	return " %f%m%r%h "
end

function M.colour()
	return "%*"
end

M.events.opts.callback({ file = vim.uv.cwd() })

return M
