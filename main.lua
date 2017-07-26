require "keys"

en_us = {
	{leftgutter = 10, [[Esc]],[[`]],"1","2","3","4","5","6","7","8","9","0","-","="},
	{leftgutter = 15, [[Tab]],"q","w","e","r","t","y","u","i","o","p","[","]",[[\]]},
	{leftgutter = 25, [[Caps]],"a","s","d","f","g","h","j","k","l",";",[[']],"Enter"},
	{leftgutter = 35, [[Shift]],"z","x","c","v","b","n","m",[[,]],[[.]],[[/]],[[Shift]]},
}

en_dv = {
	{leftgutter = 10, [[Esc]],[[`]],"1","2","3","4","5","6","7","8","9","0","[","]"},
	{leftgutter = 15, [[Tab]],[[']],[[,]],[[.]],"p","y","f","g","c","r","l",[[/]],"=",[[\]]},
	{leftgutter = 25, [[Caps]],"a","o","e","u","i","d","h","t","n","s","-","Enter"},
	{leftgutter = 35, [[Shift]],";","q","j","k","x","b","m","w","v","z",[[Shift]]},
}

layout = en_us
keywidth, keyheight = 80, 80 --Placeholder values, maybe we can detect DPI to change these
keymargin_x, keymargin_y = keywidth/10, keyheight/10 --Placeholder values
labeloffset_x, labeloffset_y = 20, 15
last_input_was_mouse = false --To stop the infinite hover from an invisible mouse cursor.
touches = {}

function love.load()
	love.window.setTitle("Best Keyboard Ever")
	love.window.setMode(1280, 400, {resizable = true})
	global_keys = generate_keys(layout)
end

function love.update()
	--Iterate over the keys, and mark the one (if any) that's being hovered.
	--keys_map(global_keys, key_set_hover_state)
end

function love.mousepressed(x, y, button, istouch)
	keys_map(global_keys, function(key)
		if not istouch and key_collide(key, x, y) then
			if button == 1 then
				emit_keypress(key)
			end
		end
	end)
end

function love.mousemoved(x, y, dx, dy, istouch)
	last_input_was_mouse = not istouch
end

function love.touchpressed(id, x, y, dx, dy, pressure)
	touches[id] = {x = x, y = y, pressure = pressure}
end

function love.touchmoved(id, x, y, dx, dy, pressure)

end

function love.touchreleased(id, x, y, dx, dy, pressure)
	local tx, ty = touches[id].x, touches[id].y
	dx, dy = x - tx, y - ty
	keys_map(global_keys, function(key)
		if key_collide(key, x, y) and key_collide(key, tx, ty) then
			emit_keypress(key)
		end
	end)

	if dx > 0 then print "To the right"
	elseif dx < 0 then print "To the left" end
	if dy > 0 then print "Down"
	elseif dy < 0 then print "Up" end
	touches[id] = nil
end

function love.draw()
	love.graphics.clear(26, 26, 26)

	keys_map(global_keys, function(key)
		local x, y = love.mouse.getPosition()
		local mouse_over = key_collide(key, x, y) 
		local is_pressed = love.mouse.isDown(1) and mouse_over and last_input_was_mouse
		local dragged_x, dragged_y = 0, 0
		for id, press in pairs(touches) do
			local x, y = love.touch.getPosition(id)
			local tx, ty = touches[id].x, touches[id].y
			dragged_x, dragged_y = x - tx, y - ty
			if key_collide(key, tx, ty) then is_pressed = true end
		end

		local text_color = {235, 235, 235}
		if is_pressed then
			love.graphics.setColor(72, 104, 96, 255)
		elseif mouse_over and last_input_was_mouse then
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
