en_us = {
	{leftgutter = 10, "Esc","`","1","2","3","4","5","6","7","8","9","0","-","="},
	{leftgutter = 15, "Tab","q","w","e","r","t","y","u","i","o","p","[","]",[[\]]}, --Double square brackets are an alternative to quotes
	{leftgutter = 25, --[[To be filled in]] [["]]},
	{leftgutter = 35, --[[To be filled in]]},
	{leftgutter = 45, --[[To be filled in]]}
}

layout = en_us
scales = {
	tab = 1.5,
	shift = 2.0,
}
keywidth, keyheight = 50, 50 --Placeholder values, maybe we can detect DPI to change these
keymargin_x, keymargin_y = keywidth/10, keyheight/10 --Placeholder values

function love.load()
	love.window.setTitle("Best Keyboard Ever")
	love.window.setMode(1280, 400, {resizable = true})
end

function love.draw()
	love.graphics.clear(26, 26, 26)
	love.graphics.setColor(51,51,51,255)

	for row_i, row in ipairs(layout) do
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

			love.graphics.rectangle("fill", x, y, width, height)
			x = x + width + keymargin_x * 2
		end
	end
end