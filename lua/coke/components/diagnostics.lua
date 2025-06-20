local M = {
	warn = 0,
	error = 0,

	diagnostics = {},
	winbuf = {},
}

local HINT = vim.diagnostic.severity.HINT
local WARN = vim.diagnostic.severity.WARN
local ERROR = vim.diagnostic.severity.ERROR

M.events = { {
	kind = "User",
	opts = {
		pattern = "CokeDiagnostic",
		callback = function(_) end,
	},
}, {
	kind = "BufWinEnter",
	opts = {
		callback = function(ev)
			local winnr = vim.api.nvim_get_current_win()
			local cfg = vim.api.nvim_win_get_config(winnr)
			if not cfg.zindex then
				M.winbuf[winnr] = ev.buf
			end
		end,
	},
}, {
	kind = { "WinClosed" },
	opts = {
		callback = function(ev)
			M.winbuf[tonumber(ev.file)] = nil
		end,
	},
} }

vim.diagnostic.handlers["coke/notify"] = {
	show = function(_, _, diagnostics, _)
		for _, diagnostic in ipairs(diagnostics) do
			local bufnr = diagnostic.bufnr
			if bufnr then
				if not M.diagnostics[bufnr] then
					M.diagnostics[bufnr] = { [HINT] = 0, [WARN] = 0, [ERROR] = 0 }
				end
				M.diagnostics[bufnr][diagnostic.severity] = M.diagnostics[bufnr][diagnostic.severity] + 1
			end
		end

		vim.api.nvim_exec_autocmds("User", { pattern = "CokeDiagnostic" })
	end,
	hide = function(_, bufnr)
		M.diagnostics[bufnr] = nil
	end,
}

vim.diagnostic.config({
	["coke/notify"] = {
		log_level = vim.log.levels.INFO,
		severity = { HINT, WARN, ERROR },
	},
})

function M:fmt(ctx)
	if not ctx.active then
		return ""
	end
	local winbuf = M.winbuf[ctx.winnr]
	local diagnostics = M.diagnostics[winbuf]
	if not diagnostics then
		return ""
	end

	local hints, warns, errs = diagnostics[HINT], diagnostics[WARN], diagnostics[ERROR]

	local output = ""
	if hints > 0 then
		output = output .. " H:" .. tostring(hints)
	end
	if warns > 0 then
		output = output .. " W:" .. tostring(warns)
	end
	if errs > 0 then
		output = output .. " E:" .. tostring(errs)
	end
	if output:len() == 0 then
		return output
	end
	return output .. " "
end

function M.colour(_)
	return {
		fg = "#212121",
		bg = "#af5f5a",
	}
end

return M
