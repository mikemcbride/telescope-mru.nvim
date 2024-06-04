local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local plenary_path = require("plenary.path")
local cdir = vim.fn.getcwd()
local if_nil = vim.F.if_nil

local mru_files = function(opts)
    opts = opts or {}

    local function get_extension(fn)
        local match = fn:match("^.+(%..+)$")
        local ext = ""
        if match ~= nil then
            ext = match:sub(2)
        end
        return ext
    end

    local default_mru_ignore = { "gitcommit" }

    local mru_opts = {
        ignore = function(path, ext)
            return (string.find(path, "COMMIT_EDITMSG") > 0) or (vim.tbl_contains(default_mru_ignore, ext))
        end,
        max_items = 50
    }

    local mru = function(cwd, local_opts)
        local_opts = local_opts or mru_opts

        -- default to 50 recent files if not present in options
        local max_items = if_nil(local_opts.max_items, 50)

        local oldfiles = {}
        for _, v in pairs(vim.v.oldfiles) do
            if #oldfiles == max_items then
                break
            end
            local cwd_cond
            if not cwd then
                cwd_cond = true
            else
                cwd_cond = vim.startswith(v, cwd)
            end
            print("path: " .. v)
            print("find commit_editmsg:" .. string.find(v, "COMMIT_EDITMSG"))
            local ignore = (local_opts.ignore and local_opts.ignore(v, get_extension(v))) or false
            if (vim.fn.filereadable(v) == 1) and cwd_cond and not ignore then
                oldfiles[#oldfiles + 1] = v
            end
        end
        local target_width = 35

        local tbl = {}
        for i, fn in ipairs(oldfiles) do
            local short_fn
            if cwd then
                short_fn = vim.fn.fnamemodify(fn, ":.")
            else
                short_fn = vim.fn.fnamemodify(fn, ":~")
            end

            if #short_fn > target_width then
                short_fn = plenary_path.new(short_fn):shorten(1, { -2, -1 })
                if #short_fn > target_width then
                    short_fn = plenary_path.new(short_fn):shorten(1, { -1 })
                end
            end
            tbl[i] = { fn, short_fn }
        end
        return tbl
    end

    pickers.new(opts, {
        prompt_title = "Recent Files",
        finder = finders.new_table {
            results = mru(cdir, opts),
            entry_maker = function(entry)
                return {
                    value = entry,
                    path = entry[1],
                    display = entry[2],
                    ordinal = entry[2],
                }
            end
        },
        previewer = conf.file_previewer(opts),
        sorter = conf.file_sorter(opts),
    }):find()
end

return require("telescope").register_extension {
    setup = function(ext_config, config)
        -- access extension config and user config
    end,
    exports = {
        mru_files = mru_files
    },
}
