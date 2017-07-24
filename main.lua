en_us = {
	{"Esc","`","1","2","3","4","5","6","7","8","9","0","-","=",   leftgutter = 0},
	{"Tab","q","w","e","r","t","y","u","i","o","p","[","]",[[\]], leftgutter = 10}, --Double square brackets are an alternative to quotes
	{--[[To be filled in]] [["]], leftgutter = 20},
	{--[[To be filled in]] leftgutter = 30},
	{--[[To be filled in]] leftgutter = 40}
}

layout = en_us
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
		keystart_x = row.leftgutter or 0
		for key_i, key in ipairs(row) do
			--Special-case keys set x, y, width and height
			--else
			local x, y = keystart_x, row_i * (keyheight + keymargin_y * 2)
			local width, height = keywidth, keyheight
			love.graphics.rectangle("fill", x, y, width, height)
			keystart_x = keystart_x + width + keymargin_x * 2
		end
	end
end