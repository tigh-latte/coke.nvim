local M = {}

function M:fmt()
	return " %{&filetype} "
end

function M.colour()
	return "%#CokeTransparent#"
end

return M
