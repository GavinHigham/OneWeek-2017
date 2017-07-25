--Returns a table indexable by [row_i][key_i] to retrieve each key's x, y, width, height, and other key state.
function generate_keys(keylayout)
	local keys = {}

	for row_i, row in ipairs(layout) do
		keys[row_i] = {}
		local x = row.leftgutter or 0
		local y = row_i * (keyheight + keymargin_y * 2)

		for key_i, key in ipairs(row) do
			local width, height = keywidth, keyheight

			--Special-case keys
			if key == "Tab" then
				width = width * scales.tab
			elseif key == "Shift" then
				width = width * scales.shift
			end

			keys[row_i][key_i] = {x = x, y = y, width = width, height = height, text = key}
			x = x + width + keymargin_x * 2
		end
	end

	return keys
end

--Returns true if x,y is a point in key.
function key_collide(key, x, y)
	return (x >= key.x and x <= key.x + key.width) and (y >= key.y and y <= key.y + key.height)
end

--Calls action for each key, passing said key as the argument.
function keys_map(keys, action)
	for row_i, row in ipairs(keys) do
		for key_i, key in ipairs(row) do
			action(key)
		end
	end
end

--Sets the key's hover state if the mouse is within the key bounds.
function key_set_hover_state(key)
	local x, y = love.mouse.getPosition()
	if key_collide(key, x, y) then
		key.is_hover = true
	else
		key.is_hover = false
	end
end