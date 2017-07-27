require "layouts"

--Used to suppress or alter printing of particular key labels.
named_keys = {
	text = {
		Esc = "",
		Tab = "\t",
		Caps = "",
		Space = " ",
		Enter = "\n",
		Shift = "",
	},
	scales = {
		Tab = 1.5,
		Ctrl = 1.2,
		Win = 1.2,
		Alt = 1.2,
		Shift = 2.0,
		Enter = 2.0,
		Caps = 1.7,
		Space = 5.5,
	}
}

key_drags = {
	--Key string = {drag-up, drag-left, drag-right, drag-down}
	--Number row gets special drags because it doesn't change much between layouts.
	["`"] = {"~", nil, nil, nil},
	["1"] = {"!", nil, nil, "if"},
	["2"] = {"@", nil, nil, "else"},
	["3"] = {"#", nil, nil, "for"},
	["4"] = {"$", nil, nil, "while"},
	["5"] = {"%", nil, nil, "do"},
	["6"] = {"^", nil, nil, "include"},
	["7"] = {"&", "<", ">", nil},
	["8"] = {"*", "[", "]", nil},
	["9"] = {nil, "(", ")", nil},
	["0"] = {nil, "{", "}", nil},
	--Other characters get their shift-characters accessible from a drag.
	["="] = {"+"},
	["-"] = {"_"},
}

--Returns a table indexable by [row_i][key_i] to retrieve each key's x, y, width, height, and other key state.
function generate_keys(keylayout)
	local keys = {}

	for row_i, row in ipairs(layout) do
		keys[row_i] = {}
		local x = row.leftgutter or 30
		local y = (row_i-1) * (keyheight + keymargin_y * 2) + keymargin_y

		for key_i, key in ipairs(row) do
			local width, height = keywidth, keyheight
			local lx, ly = labeloffset_x, labeloffset_y

			--Special-case keys
			width = width * (named_keys.scales[key] or 1)

			keys[row_i][key_i] = {
				x = x, y = y,
				width = width, height = height,
				text = key, corner_radius = 5,
				label_x = lx+x, label_y = ly+y
			}
			x = x + width + keymargin_x * 2
		end
	end

	return keys
end

function key_drag_index(dx, dy)
	local a, b = dx > dy, dx > -dy
	if a and not b then return 1
	elseif not a and not b then return 2
	elseif a and b then return 3
	elseif not a and b then return 4
	end
	return nil
end

function emit_keypress(keytext)
	--Special case logic can occur here.
	io.write(named_keys.text[keytext] or keytext)
	io.flush()
end

--Returns true if x,y is a point in a rectangle positioned at rx,ry with width,height of rw,rh.
function rect_collide(rx, ry, rw, rh, x, y)
	return (x >= rx and x <= rx + rw) and (y >= ry and y <= ry + rh)
end

--Returns true if x,y is a point in a circle positioned at sx,sy with radius r.
function circ_collide(sx, sy, r, x, y)
	local dx, dy = sx-x, sy-y
	return dx*dx + dy*dy <= r*r
end

--Returns true if x,y is a point in key.
function key_collide(key, x, y)
	local r = key.corner_radius or 0
	local r2 = 2*r
	return rect_collide(key.x+r, key.y,   key.width-r2, key.height,    x, y) or
	       rect_collide(key.x,   key.y+r, key.width,    key.height-r2, x, y) or
	       circ_collide(key.x+r,           key.y+r,            r, x, y) or --Top-left corner
	       circ_collide(key.x+key.width-r, key.y+r,            r, x, y) or --Top-right corner
   	       circ_collide(key.x+key.width-r, key.y+key.height-r, r, x, y) or --Bottom-right corner
   	       circ_collide(key.x+r,           key.y+key.height-r, r, x, y)    --Bottom-left corner
end

--Calls action for each key, passing said key as the argument.
function keys_map(keys, action)
	for row_i, row in ipairs(keys) do
		for key_i, key in ipairs(row) do
			action(key)
		end
	end
end