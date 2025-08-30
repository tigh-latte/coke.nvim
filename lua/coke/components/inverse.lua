local M = {}
M.__index = M

---@param text string
---@param hide_inactive boolean?
function M.new(text, hide_inactive)
	local obj = setmetatable({}, M)
	obj.text = text
	obj.hide_inactive = hide_inactive ~= nil and hide_inactive or true
	return obj
end

function M:fmt(ctx)
	return self.hide_inactive and (ctx.active and self.text or "") or self.text
end

function M.colour(ctx)
	local mode = vim.api.nvim_get_mode().mode
	if ctx.modes[mode] == nil then return end
	local clr = vim.deepcopy(ctx.modes[vim.api.nvim_get_mode().mode].hl)
	clr.reverse = clr.reverse ~= nil and not clr.reverse or true

	return clr
end

return M
