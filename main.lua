require "keys"

en_us = {
	{leftgutter = 10, [[Esc]],"`","1","2","3","4","5","6","7","8","9","0","-","="},
	{leftgutter = 15, [[Tab]],"q","w","e","r","t","y","u","i","o","p","[","]",[[\]]},
	{leftgutter = 25, [[Caps]],"a","s","d","f","g","h","j","k","l","p","[";"]",[[']]},
	{leftgutter = 35, [[Shift]],"z","x","c","v","b","n","m",[[,]],[[.]],[[/]],[[Shift]]},
}

--Used to suppress or alter printing of particular key labels.
named_keys = {
	Esc = "",
	Tab = "\t",
	Caps = "",
	Space = " ",
	Enter = "\n",
	Shift = "",
}
--Used to alter the size of particular keys.
scales = {
	tab = 1.5,
	shift = 2.0,
}

layout = en_us
keywidth, keyheight = 50, 50 --Placeholder values, maybe we can detect DPI to change these
keymargin_x, keymargin_y = keywidth/10, keyheight/10 --Placeholder values
labeloffset_x, labeloffset_y = 20, 15

function love.load()
	love.window.setTitle("Best Keyboard Ever")
	love.window.setMode(1280, 400, {resizable = true})
	global_keys = generate_keys(layout)
end

function love.update()
	--Iterate over the keys, and mark the one (if any) that's being hovered.
	keys_map(global_keys, key_set_hover_state)
end

function love.mousepressed(x, y, button, istouch)
	keys_map(global_keys, function(key)
		if key_collide(key, x, y) then
			if button == 1 then
				io.write(named_keys[key.text] or key.text)
				io.flush()
			end
		end
	end)
end

function love.draw()
	love.graphics.clear(26, 26, 26)

	keys_map(global_keys, function(key)
		local text_color = {235, 235, 235}
		if key.is_hover and love.mouse.isDown(1) then
			love.graphics.setColor(72, 104, 96, 255)
		elseif key.is_hover then
			love.graphics.setColor(235,235,235,255)
			text_color = {16, 16, 16}
		else
			love.graphics.setColor(51,51,51,255)
		end
		love.graphics.rectangle("fill", key.x, key.y, key.width, key.height, key.corner_radius or 0)
		love.graphics.setColor(text_color[1], text_color[2], text_color[3])
		local text = key.text
		if love.keyboard.isDown("capslock", "rshift", "lshift") and #text == 1 then text = string.upper(text) end
		love.graphics.print(text, key.label_x, key.label_y)
	end)
end
