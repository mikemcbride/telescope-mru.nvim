# telescope-mru.nvim

Project-wide recent file picker for Telescope

## Requirements

- Neovim (>= 0.9.0)
- Telescope

## Installation

Install the plugin with your preferred package manager:

```
--lazy
{
    "mikemcbride/telescope-mru.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
}

-- packer
use {
    "mikemcbride/telescope-mru.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
}
```

## Setup and Configuration

You can configure the plugin like any other Telescope picker. You can see the available options below.

```
-- You don't need to set any of these options.
-- IMPORTANT!: this is only a showcase of how you can set default options!
require("telescope").setup {
  extensions = {
    telescope_mru = {
      theme = "ivy",
    },
  },
}
-- To get telescope-mru loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
require("telescope").load_extension "telescope_mru"
```

## Usage

You can use the `telescope-mru` plugin as follows:

```
vim.keymap.set("n", "<space>sr", ":Telescope find_mru_files<CR>")

-- Alternatively, using lua API
vim.keymap.set("n", "<space>fb", function()
	require("telescope").extensions.telescope_mru.find_mru_files()
end)
```

### Options

The `find_mru_files` can take an options table. The default values are below:

```
mru_opts = {
    ignore = function(path, ext)
        return (string.find(path, "COMMIT_EDITMSG")) or (vim.tbl_contains(default_mru_ignore, ext))
    end,
    max_items = 50
}
```

- *ignore* is a function that takes a path and file extension and returns a boolean. It should return `true` if the file should be ignored from the list.
- *max_items* is the maximum number of items the picker should show. If omitted, it will default to 50.
