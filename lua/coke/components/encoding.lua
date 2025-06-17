local M = {}

function M:fmt()
	return " %{&fileencoding}[%{&fileformat}] "
end

function M.colour(ctx)
	if not ctx.active then
		return "%#CokeTransparent#"
	end

	return {
		bg = "#444444",
		fg = "#abb2bf",
	}
end

return M
