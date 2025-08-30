local M = {
	output = "",
}

local function cb(_)
	M.head = vim.fn.FugitiveHead()
	M.is_main = M.head == "main" or M.head == "master"
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
	kind = { "BufWritePost", "BufEnter", "BufWinEnter", "FocusGained" },
	opts = {
		callback = cb,
	},
} }

function M:fmt(ctx)
	if not ctx.active or vim.fn.FugitiveIsGitDir() == 0 or vim.bo.bt ~= "" then return "" end
	return M.output
end

function M.colour()
	if M.is_main and M.dirty then
		return {
			bg = "#af5f5a",
			fg = "#212121",
			bold = true,
		}
	end

	return {
		bg = "#444444",
		fg = "#abb2bf",
		bold = true,
	}
end

return M
