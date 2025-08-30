local M = {
	wins = setmetatable({}, {
		__index = function(t, k)
			t[k] = {}
			return t
		end,
	}),
	bufs = {},
	---@type coke.Config
	config = {
		enabled = true,
		components = {
			left = {
				require("coke.components.inverse").new("██"),
				require("coke.components.mode"),
				require("coke.components.fugitive"),
				require("coke.components.file"),
			},
			right = {
				require("coke.components.ft"),
				require("coke.components.encoding"),
				require("coke.components.diagnostics"),
				require("coke.components.location"),
				require("coke.components.inverse").new("█"),
			},
		},
		modes = {
			n = { txt = "NORMAL", hl = { bg = "#d7af87", bold = true, fg = "#212121" } },
			niI = { txt = "NORMAL", hl = { bg = "#d7af87", fg = "#212121" } },
			no = { txt = "NORMAL", hl = { bg = "#d7af87" } },
			i = { txt = "INSERT", hl = { bg = "#73b8f1", bold = true, fg = "#212121" } },
			["r?"] = { txt = "REPLACE", hl = { bg = "#af5f5a", fg = "#212121" } },
			R = { txt = "REPLACE", hl = { bg = "#af5f5a", fg = "#212121" } },
			Rv = { txt = "REPLACE", hl = { bg = "#af5f5a", fg = "#212121" } },
			ic = { txt = "IC", hl = { bg = "#53892c", bold = true, fg = "#212121" } },
			ix = { txt = "INS-X", hl = { bg = "#53892c", fg = "#212121" } },
			c = { txt = "COMMAND", hl = { bg = "#53892c", bold = true, fg = "#212121" } },
			v = { txt = "VISUAL", hl = { bg = "#d19a66", bold = true, fg = "#212121" } },
			V = { txt = "VISUAL-LINE", hl = { bg = "#d19a66", bold = true, fg = "#212121" } },
			[""] = { txt = "VISUAL-BLOCK", hl = { bg = "#d19a66", bold = true, fg = "#212121" } },
			s = { txt = "SELECT", hl = { bg = "#d19a66", bold = true, fg = "#212121" } },
			S = { txt = "SELECT", hl = { bg = "#d19a66", bold = true, fg = "#212121" } },
			nt = { txt = "TERMINAL", hl = { bg = "#53892c", fg = "#212121" } },
			t = { txt = "TERMINAL", hl = { bg = "#53892c", fg = "#212121" } },
		},
	},

	state = {},
}

---@param config coke.Config
function M.setup(config)
	M.config = vim.tbl_deep_extend("force", M.config, config)

	vim.api.nvim_create_user_command("CokeToggle", function(_)
		M.toggle()
	end, {})

	if M.config.enabled then
		M.init()
	end
end

function M.toggle()
	M.enabled = not M.enabled
end

function M.init()
	M.wins[vim.api.nvim_get_current_win()].active = true
	M.state.augroup = vim.api.nvim_create_augroup("coke.nvim", { clear = true })

	vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" },
		{
			group = M.state.augroup,
			callback = M.wrap(function(_)
				local win_cfg = vim.api.nvim_win_get_config(vim.api.nvim_get_current_win())
				if not win_cfg.zindex then
					M.wins[vim.api.nvim_get_current_win()].active = true
				end
			end),
		}
	)

	vim.api.nvim_create_autocmd({ "BufWinLeave", "WinLeave" },
		{
			group = M.state.augroup,
			callback = M.wrap(function(ev)
				local win = M.wins[vim.api.nvim_get_current_win()]
				if ev.event == "WinLeave" and win then
					M.wins[vim.api.nvim_get_current_win()].active = false
				end
			end),
		}
	)

	vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })

	---@param event coke.EventHandler
	local add_event = function(event)
		if type(event.opts.callback) == "function" then
			---@diagnostic disable-next-line: param-type-mismatch
			event.opts.callback = M.wrap(event.opts.callback)
		end
		vim.api.nvim_create_autocmd(event.kind, event.opts)
	end
	for _, component in ipairs(M.config.components.left) do
		if component.events ~= nil then
			if vim.isarray(component.events) then
				for _, event in ipairs(component.events) do
					add_event(event)
				end
			else
				add_event(component.events)
			end
		end
	end

	for _, component in ipairs(M.config.components.right) do
		if component.events ~= nil then
			if vim.isarray(component.events) then
				for _, event in ipairs(component.events) do
					add_event(event)
				end
			else
				add_event(component.events)
			end
		end
	end
end

function M.teardown()
	vim.api.nvim_del_augroup_by_id(M.state.augroup)
end

---@param fn fun(args: vim.api.keyset.create_autocmd.callback_args): boolean?
---@return fun(args: vim.api.keyset.create_autocmd.callback_args): boolean?
function M.wrap(fn)
	return function(ev)
		local ret = fn(ev)
		M.refresh_status(ev)
		return ret
	end
end

---@param ev vim.api.keyset.create_autocmd.callback_args
function M.refresh_status(ev)
	local output = {}

	---@param i integer
	---@param dir "Left"|"Right
	---@param winnr integer
	---@param component coke.Component
	local render_part = function(i, dir, winnr, component)
		local hl_name = "Coke" .. dir .. tostring(i) .. "W" .. tostring(winnr)
		local ctx = {
			modes = M.config.modes,
			hl = "",
			hl_rev = "",
			bufnr = ev.buf,
			winnr = vim.api.nvim_get_current_win(),
			active = M.wins[vim.api.nvim_get_current_win()].active,
		} --[[@as coke.Context]]

		local colour
		if component.colour == nil then
			colour = ctx.active and ctx.modes[vim.api.nvim_get_mode().mode].hl or "%*"
		elseif type(component.colour) == "function" then
			colour = component.colour(ctx)
			if colour == nil then
				colour = ctx.modes[vim.api.nvim_get_mode().mode].hl
			end
		else
			colour = component.colour
		end

		if colour == nil then
			ctx.hl = "%*"
		elseif type(colour) == "string" then
			ctx.hl = colour
		else
			vim.api.nvim_set_hl(0, hl_name, colour)
			ctx.hl = "%#" .. hl_name .. "#"

			local glyph = vim.deepcopy(colour)
			glyph.reverse = colour.reverse ~= nil and not colour.reverse or true
			vim.api.nvim_set_hl(0, hl_name .. "Glyph", glyph)
			ctx.hl_rev = "%#" .. hl_name .. "Glyph#"
		end

		table.insert(output, ctx.hl)
		local txt = component:fmt(ctx)
		table.insert(output, txt)
	end

	local winnr = vim.api.nvim_get_current_win()
	for i, component in ipairs(M.config.components.left) do
		render_part(i, "Left", winnr, component)
	end

	table.insert(output, "%*%= ")

	for i, component in ipairs(M.config.components.right) do
		render_part(i, "Right", winnr, component)
	end
	table.insert(output, "%*")

	vim.wo.statusline = table.concat(output)
end

return M
