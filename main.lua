require "keys"

en_us = {
	{leftgutter = 10, [[Esc]],"`","1","2","3","4","5","6","7","8","9","0","-","="},
	{leftgutter = 15, [[Tab]],"q","w","e","r","t","y","u","i","o","p","[","]",[[\]]}, --Double square brackets are an alternative to quotes
	{leftgutter = 25, [[Caps]],"a","s","d","f","g","h","j","k","l","p","[";"]",[[']]},
	{leftgutter = 35, [[Shift]],"z","x","c","v","b","n","m",[[,]],[[.]],[[/]],[[Shift]]},
	{leftgutter = 45, [[Shift]],"z","x","c","v","b","n","m",[[,]],[[.]],[[/]],[[Shift]]}
}

layout = en_us
scales = {
	tab = 1.5,
	shift = 2.0,
}

keywidth, keyheight = 50, 50 --Placeholder values, maybe we can detect DPI to change these
keymargin_x, keymargin_y = keywidth/10, keyheight/10 --Placeholder values
mouseover_key = nil

function love.load()
	love.window.setTitle("Best Keyboard Ever")
	love.window.setMode(1280, 400, {resizable = true})
	global_keys = generate_keys(layout)
end

function love.update()
	local x, y = love.mouse.getPosition()
	local key = key_collide(global_keys, x, y,
		function (key) key.is_hover = true end,
		function (key) key.is_hover = false end)
end

function love.draw()
	love.graphics.clear(26, 26, 26)

	for row_i, row in ipairs(layout) do
		for key_i, key in ipairs(row) do
			key = global_keys[row_i][key_i]
			if key.is_hover then
				key.is_hover = false
				love.graphics.setColor(235,235,235,255)
			else
				love.graphics.setColor(51,51,51,255)
			end
			love.graphics.rectangle("fill", key.x, key.y, key.width, key.height)
		end
	end
end
