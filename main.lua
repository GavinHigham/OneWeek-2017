require "keys"

layout = en_dv

keywidth, keyheight = 85, 85 --Placeholder values, maybe we can detect DPI to change these
keymargin_x, keymargin_y = keywidth/20, keyheight/20 --Placeholder values
labeloffset_x, labeloffset_y = keywidth/2, keyheight/2
last_input_was_mouse = false --To stop the infinite hover from an invisible mouse cursor.
touches = {}

function love.load()
	love.window.setTitle("Best Keyboard Ever")
	local width, height = love.window.getDesktopDimensions()
	local keyboard_height = (keyheight+keymargin_y*2)*5
	love.window.setMode(width, keyboard_height, {resizable = true, x = 0, y = height-keyboard_height, highdpi = true})
	global_keys = generate_keys(layout)
	font = love.graphics.newFont("UbuntuMono-R.ttf", 20)
	love.graphics.setFont(font)
end

function love.update()
	--Iterate over the keys, and mark the one (if any) that's being hovered.
	--keys_map(global_keys, key_set_hover_state)
end

function love.mousepressed(x, y, button, istouch)
	keys_map(global_keys, function(key)
		if not istouch and key_collide(key, x, y) then
			if button == 1 then
				emit_keypress(key.text)
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
		--Touch started in this key
		if key_collide(key, tx, ty) then
			--Touch ended in this same key
			if key_collide(key, x, y) then
				emit_keypress(key.text)
			else
				--If there's a key drag, use it, otherwise emit the empty string.
				emit_keypress((key_drags[key.text] or {})[key_drag_index(dx, dy)] or "")
			end
		end
		--We don't care about touches that end in this key if they didn't start here.
	end)

	touches[id] = nil
end

function love.draw()
	love.graphics.clear(26, 26, 26)

	keys_map(global_keys, function(key)
		local x, y = love.mouse.getPosition()
		local mouse_over = key_collide(key, x, y) 
		local is_pressed = love.mouse.isDown(1) and mouse_over and last_input_was_mouse
		local is_dragged = false
		local dragged_x, dragged_y = 0, 0
		local drag_index = nil
		for id, press in pairs(touches) do
			local x, y = love.touch.getPosition(id)
			local tx, ty = touches[id].x, touches[id].y
			dragged_x, dragged_y = x - tx, y - ty
			if key_collide(key, tx, ty) then is_pressed = true end
			if is_pressed and not key_collide(key, x, y) then
				is_dragged = true
				drag_index = key_drag_index(dragged_x, dragged_y)
			end
		end

		local text_color = {235, 235, 235}
		local deselected_color = {115, 115, 115}
		if is_pressed then
			love.graphics.setColor(72, 104, 96, 255)
		elseif mouse_over and last_input_was_mouse then
			love.graphics.setColor(235,235,235,255)
			text_color = {16, 16, 16}
		else
			love.graphics.setColor(51,51,51,255)
		end
		love.graphics.rectangle("fill", key.x, key.y, key.width, key.height, key.corner_radius or 0)
		love.graphics.setColor(text_color)
		local text = key.text
		if love.keyboard.isDown("capslock", "rshift", "lshift") and #text == 1 then text = string.upper(text) end
		if is_dragged then love.graphics.setColor(deselected_color) end
		love.graphics.print(text, key.label_x-font:getWidth(text)/2, key.label_y-font:getHeight()/2, 0)
		local drags = key_drags[key.text]
		if drags then
			--HACKY CODE FTW
			for i = 1, 4 do
				if is_dragged and drag_index == i then love.graphics.setColor(text_color) else love.graphics.setColor(deselected_color) end
				if drags[i] then
					if i == 1 then love.graphics.print(drags[i], key.label_x-font:getWidth(drags[i])/2, key.label_y-font:getHeight()*1.5, 0) end
					if i == 2 then love.graphics.print(drags[i], key.label_x-font:getWidth(text)/2-font:getWidth(drags[i])*2, key.label_y-font:getHeight()/2, 0) end
					if i == 3 then love.graphics.print(drags[i], key.label_x+font:getWidth(text)/2+font:getWidth(drags[i]), key.label_y-font:getHeight()/2, 0) end
					if i == 4 then love.graphics.print(drags[i], key.label_x-font:getWidth(drags[i])/2, key.label_y+font:getHeight()*0.5, 0) end
				end
			end
		end
	end)
end
