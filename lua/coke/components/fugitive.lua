local M = {
	output = "",
}

local function cb(_)
	M.head = vim.fn.FugitiveHead()
	M.output = " ᚠ " .. M.head

	local exec = vim.fn.FugitiveExecute(
		"--no-optional-locks",
		"status",
		"-uno",
		"--porcelain",
		"--ignore-submodules"
	).stdout

	if #exec == 1 and exec[1] == "" then
		M.dirty = false
	else
		M.dirty = true
		M.output = M.output .. "!"
	end

	M.output = M.output .. " "
end

M.events = { {
	kind = "User",
	opts = {
		pattern = "FugitiveChanged",
		callback = cb,
	},
}, {
	kind = { "BufEnter", "BufWinEnter" },
	opts = {
		callback = cb,
	},
} }

function M.fmt()
	if vim.fn.FugitiveIsGitDir() == 0 then
		return ""
	end

	return M.output
end

function M.colour()
	local head = vim.fn.FugitiveHead()
	if head == "main" or head == "master" then
		return {
			bg = M.dirty and "#af5f5a" or "#d19a66",
			fg = "#212121",
			bold = true,
		}
	end

	return {
		bg = "#444444",
		fg = "#ABB2BF",
		bold = true,
	}
end

return M
