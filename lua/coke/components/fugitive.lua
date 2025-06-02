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
	kind = { "BufWritePost", "BufEnter", "BufWinEnter" },
	opts = {
		callback = cb,
	},
} }

function M.fmt(ctx)
	if not ctx.active or vim.fn.FugitiveIsGitDir() == 0 then return "" end
	return M.output -- .. ctx.hl_rev .. ""
end

function M.colour()
	if not M.dirty then
		return {
			bg = "#444444",
			fg = "#abb2bf",
			bold = true,
		}
	end

	if not M.is_main then
		return {
			bg = "#73b8f1",
			fg = "#212121",
			bold = true,
		}
	else
		return {
			bg = "#af5f5a",
			fg = "#212121",
			bold = true,
		}
	end
end

return M
