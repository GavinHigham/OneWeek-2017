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
			keys[row_i][key_i] = {x = x, y = y, width = width, height = height}
			x = x + width + keymargin_x * 2
		end
	end

	return keys
end