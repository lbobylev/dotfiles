local monokai = {
    bg = "#272822",
    fg = "#F8F8F2",
    black = "#1B1C1B",
    gray = "#75715E",
    pink = "#F92672",
    green = "#A6E22E",
    yellow = "#E6DB74",
    blue = "#66D9EF",
    orange = "#FD971F",
    purple = "#AE81FF",
}

require("yatline"):setup({
    show_background = false,

    style_a = {
        fg = monokai.black, -- black text on orange background (mode)
        bg_mode = {
            normal = monokai.orange,
            insert = monokai.green,
            visual = monokai.pink,
            command = monokai.blue,
        },
    },
    style_b = { bg = monokai.bg, fg = monokai.orange }, -- branch/diff
    style_c = { bg = monokai.bg, fg = monokai.fg }, -- filename

    -- Permissions: Using standard Monokai accents
    -- t (sticky): Often special, using Purple
    permissions_t_fg = monokai.purple, -- Purple (was Green #A6E22E)
    -- r (read): Often neutral/positive, using Green
    permissions_r_fg = monokai.green,  -- Green (was Light Red #E27B82)
    -- w (write): Often danger/modification, using Pink
    permissions_w_fg = monokai.pink,   -- Pink
    -- x (execute): Often informational/actionable, using Blue/Cyan
    permissions_x_fg = monokai.blue,   -- Cyan
    -- s (setuid/setgid): Special permission, using Purple
    permissions_s_fg = monokai.purple, -- Purple (was Light Gray #F8F8F2)

    -- Status Icons: Using appropriate Monokai accents
    selected = { icon = "󰻭", fg = monokai.pink },   -- Pink
    copied = { icon = "", fg = monokai.green },  -- Green
    cut = { icon = "", fg = monokai.pink },   -- Pink (consistent with selected/action)

    -- Progress/Summary Icons
    -- total: Informational, using Blue/Cyan
    total = { icon = "󰮍", fg = monokai.blue },   -- Cyan (was Pink #F92672)
    -- succ: Success, using Green
    succ = { icon = "", fg = monokai.green },  -- Green
    -- fail: Failure/Error, using Pink
    fail = { icon = "", fg = monokai.pink },   -- Pink
    -- found: Informational, using Blue/Cyan
    found = { icon = "󰮕", fg = monokai.blue },   -- Cyan
    -- processed: Completion/Success, using Green
    processed = { icon = "󰐍", fg = monokai.green },  -- Green

	header_line = {
		left = {
			section_a = {
			},
			section_b = {
			},
			section_c = {
			}
		},
		right = {
			section_a = {
			},
			section_b = {
			},
			section_c = {
			}
		}
	},

	status_line = {
		left = {
			section_a = {
        			{type = "string", custom = false, name = "tab_mode"},
			},
			section_b = {
        			{type = "string", custom = false, name = "hovered_size"},
			},
			section_c = {
        			{type = "string", custom = false, name = "hovered_name"},
			}
		},

		right = {
			section_a = {
        			{type = "string", custom = false, name = "cursor_position"},
			},
			section_b = {
        			{type = "string", custom = false, name = "cursor_percentage"},
			},
			section_c = {
        			{type = "coloreds", custom = false, name = "permissions"},
			}
		}
	},
})
