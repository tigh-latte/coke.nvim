local M = {
	warn = 0,
	error = 0,

	winbuf = {},
}

local function cb(ev)
	local diagnostics = vim.diagnostic.get(ev.bufnr, {
		namespace = M.ns,
		severity = {
			vim.diagnostic.severity.WARN,
			vim.diagnostic.severity.ERROR,
		},
	})

	local tally = {
		[vim.diagnostic.severity.WARN] = 0,
		[vim.diagnostic.severity.ERROR] = 0,
	}
	for _, diagnostic in ipairs(diagnostics) do
		tally[diagnostic.severity] = tally[diagnostic.severity] + 1
	end
	M.warn = tally[vim.diagnostic.severity.WARN]
	M.error = tally[vim.diagnostic.severity.ERROR]
end

M.events = { {
	kind = "User",
	opts = {
		pattern = "CokeDiagnostic",
		callback = cb,
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
		callback = function(_)
			local winnr = vim.api.nvim_get_current_win()
			local cfg = vim.api.nvim_win_get_config(winnr)
			M.winbuf[winnr] = nil
		end,
	},
} }


vim.diagnostic.handlers["coke/notify"] = {
	show = function(namespace, bufnr, diagnostics, opts)
		local tally = {
			[vim.diagnostic.severity.WARN] = 0,
			[vim.diagnostic.severity.ERROR] = 0,
		}

		for _, diagnostic in ipairs(diagnostics) do
			tally[diagnostic.severity] = tally[diagnostic.severity] + 1
		end
		M.warn = tally[vim.diagnostic.severity.WARN]
		M.error = tally[vim.diagnostic.severity.ERROR]

		vim.api.nvim_exec_autocmds("User", {
			pattern = "CokeDiagnostic",
			data = { bufnr = bufnr },
		})
	end,
}

vim.diagnostic.config({
	["coke/notify"] = {
		log_level = vim.log.levels.INFO,
		severity = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.ERROR },
	},
})

function M.fmt(ctx)
	local output = ""
	if M.warn > 0 then
		output = output .. " W:" .. tostring(M.warn)
	end
	if M.error > 0 then
		output = output .. " E:" .. tostring(M.error)
	end
	if output:len() == 0 then
		return output
	end
	return output .. " "
end

function M.colour()
	return {
		fg = "#212121",
		bg = "#af5f5a",
	}
end

return M
