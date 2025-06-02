local M = {}

function M.fmt()
	if vim.bo.modified then
		return " %f[+] "
	end
	return " %f "
end

return M
