local M = {}
M.__index = M

function M.new(text)
	local obj = setmetatable({}, M)
	obj.text = text
	return obj
end

function M:fmt()
	return self.text
end

function M.colour(ctx)
	local clr = vim.deepcopy(ctx.modes[vim.api.nvim_get_mode().mode].hl)
	clr.reverse = clr.reverse ~= nil and not clr.reverse or true

	return clr
end

return M
