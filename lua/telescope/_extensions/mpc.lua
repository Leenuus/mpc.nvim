local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local previewers = require("telescope.previewers")
local utils = require("telescope.previewers.utils")

local logger = require("plenary.log")

-- TODO: refactor hardcoded
local index_file = vim.fn.expand("~/Music/index.json")

local function read_index()
	local file = io.open(index_file, "r")
	if file == nil then
		return {}
	end
	local res = file:read("*a")
	file:close()
	local j = vim.json.decode(res)
	return j
end

-- TODO: previewer: wrap lines which are too long
local function format_track(track)
	local titles = track.title
	local f_title
	if titles == nil then
		f_title = ""
	else
		f_title = vim.fn.join(titles, ", ")
	end
	local artists = track.artist
	local f_artists
	if artists == nil then
		f_artists = ""
	else
		f_artists = vim.fn.join(artists, ", ")
	end
	local albums = track.album
	local f_albums
	if albums == nil then
		f_albums = ""
	else
		f_albums = vim.fn.join(albums, ", ")
	end
	return {
		"- title: " .. f_title,
		"- artists: " .. f_artists,
		"- albums: " .. f_albums,
	}
end

local track_picker = function(opts)
	opts = opts or {}
	pickers
	    .new(opts, {
		    prompt_title = "select track to play",
		    finder = finders.new_table({
			    results = read_index(),
			    entry_maker = function(entry)
				    logger.info(entry)
				    return {
					    value = entry,
					    display = entry.title[1],
					    -- ordinal should include titles
					    ordinal = entry.title_search_term,
				    }
			    end,
		    }),
		    sorter = conf.generic_sorter(opts),
		    attach_mappings = function(prompt_bufnr, map)
			    actions.select_default:replace(function()
				    actions.close(prompt_bufnr)
				    local selection = action_state.get_selected_entry()
				    logger.info(selection)
				    local track_path = selection.value.path
				    local host = vim.env["MPD_SOCKET"]
				    if host == nil then
					    logger.info("no mpd socket fond")
				    end
				    local Job = require("plenary.job")
				    local com = {
					    command = "mpc",
					    args = {
						    "--host=" .. host,
						    "insert",
						    track_path,
					    },
				    }
				    Job:new(com):sync()
				    local com1 = {
					    command = "mpc",
					    args = {
						    "--host=" .. host,
						    "play",
					    },
				    }
				    Job:new(com1):sync()
			    end)
			    return true
		    end,
		    previewer = previewers.new_buffer_previewer({
			    title = "track",
			    define_preview = function(self, entry, status)
				    -- TODO: define highlight
				    local track = entry["value"]
				    local lines = format_track(track)
				    vim.api.nvim_buf_set_lines(self.state.bufnr, 0, 0, true, lines)
				    utils.highlighter(self.state.bufnr, "markdown")
			    end,
		    }),
	    })
	    :find()
end

return require("telescope").register_extension({
	-- TODO: give user power to change config
	setup = function(ext_config, config) end,
	exports = {
		-- file_browser = file_browser,
		-- actions = fb_actions,
		-- finder = fb_finders,
		-- NOTE: name it the same as plugin name, so it can be access without pain
		["mpc"] = track_picker,
	},
})
