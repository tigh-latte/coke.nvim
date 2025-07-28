local M = {}

function M:fmt()
	return " %{&filetype} "
end

function M.colour()
	return "%*"
end

return M
