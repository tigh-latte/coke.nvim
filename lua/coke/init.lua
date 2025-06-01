local M = {
	---@type coke.Config
	config = {
		enabled = true,
		components = {
			left = {
				require("coke.components.mode"),
				require("coke.components.fugitive"),
				require("coke.components.file"),
			},
			right = {
				require("coke.components.ft"),
				require("coke.components.location"),
			},
		},
	},

	state = {},
}

---@param config coke.Config
function M.setup(config)
	M.config = vim.tbl_deep_extend("force", M.config, config)

	vim.api.nvim_create_user_command("CokeToggle", function(args)
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
	M.state.augroup = vim.api.nvim_create_augroup("coke.nvim", { clear = true })

	vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" },
		{
			group = M.state.augroup,
			callback = M.wrap(function(args)
				M.state.buf_id = args.buf
			end),
		}
	)

	vim.api.nvim_create_autocmd({ "BufWinLeave", "WinLeave" },
		{
			group = M.state.augroup,
			callback = M.wrap(function(args)
				-- M.state.buf_id = args.buf
			end),
		}
	)


	vim.api.nvim_set_hl(0, "CokeTransparent", { bg = "#212121" })
	vim.api.nvim_set_hl(0, "CokeTransparentRev", { bg = "#212121", reverse = true })

	---@param event coke.EventHandler
	local add_event = function(event)
		if type(event.opts.callback) == "function" then
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
		M.refresh_status()
		return ret
	end
end

function M.refresh_status(ev)
	local output = {}

	---@param i integer
	---@param dir "Left"|"Right"
	---@param winnr integer
	---@param component coke.Component
	local render_part = function(i, dir, winnr, component)
		local hl_name = "Coke" .. dir .. tostring(i) .. "W" .. tostring(winnr)
		local ctx = {
			hl = "",
			hl_rev = "",
		} --[[@as coke.Context]]

		local colour = type(component.colour) == "function" and component.colour() or component.colour
		if colour == nil then
			ctx.hl = "%#CokeTransparent#"
		else
			vim.api.nvim_set_hl(0, hl_name, colour)
			ctx.hl = "%#" .. hl_name .. "#"

			colour.reverse = colour.reverse ~= nil and not colour.reverse or true
			vim.api.nvim_set_hl(0, hl_name .. "Reversed", colour)
			ctx.hl_rev = "%#" .. hl_name .. "Reversed#"
		end

		table.insert(output, ctx.hl)
		local txt = component.fmt(ctx)
		table.insert(output, txt)
	end

	local winnr = vim.api.nvim_get_current_win()
	for i, component in ipairs(M.config.components.left) do
		render_part(i, "Left", winnr, component)
	end

	table.insert(output, "%#CokeTransparent#%= %#StatusLine#")

	for i, component in ipairs(M.config.components.right) do
		render_part(i, "Right", winnr, component)
	end

	vim.wo.statusline = table.concat(output)
end

return M
