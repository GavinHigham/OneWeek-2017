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

			--Mouse-over
			if key == mouseover_key then
				love.graphics.setColor(235, 235, 235, 255)
			end

			--love.graphics.rectangle("fill", x, y, width, height)
			keys[row_i][key_i] = {x = x, y = y, width = width, height = height, text = key}
			x = x + width + keymargin_x * 2
		end
	end

	return keys
end

--If x,y is a point in a key, return that key, else return nil.
--If a collide_action is provided, call it, passing the colliding key as its sole argument.
--If a not_collide_action is provided, call it, passing any not-colliding key as its sole argument.
function key_collide(keys, x, y, collide_action, not_collide_action)
	local return_key = nil
	for row_i, row in ipairs(keys) do
		for key_i, key in ipairs(row) do
			if (x >= key.x and x <= key.x + key.width) and (y >= key.y and y <= key.y + key.height) then
				if collide_action then collide_action(key) end
				return_key = key
			else
				if not_collide_action then not_collide_action(key) end
			end
		end
	end
	return return_key
end