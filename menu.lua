local gui = require "Quickie"

menu = Gamestate.new()

function menu:init()
end

function menu:enter()	
    love.graphics.setFont(Font)
    love.graphics.setBackgroundColor(0,0,0)
    -- group defaults
    gui.group.default.size[1] = 500
    gui.group.default.size[2] = 80
    gui.group.default.spacing = 20
end

function menu:update(dt)
	gui.group.push{grow = "down", pos = {Width/2-250,20}}

	love.graphics.setFont(Font)
	gui.Label{text = "A New World", align = "center"}

	love.graphics.setFont(SmallFont)
	gui.Label{text = "This game has been created in 48h for the MiniLD #37 (theme : not-game)", align = 'center'}

	love.graphics.setFont(MenuFont)
	if gui.Button{text = "Play"} then
		Gamestate.switch(game)
	end
	if gui.Button{text = "Switch Fullscreen"} then
		love.graphics.toggleFullscreen()
	end
	if gui.Button{text = "Quit"} then
		love.event.quit()
	end
end

function menu:draw()
	gui.core.draw()
	love.graphics.setFont(SmallFont)
	love.graphics.printf("Controls : mouse & clic. This game has an ending", 0, 500, Width, 'center')

	love.graphics.printf("A game by :\
 - Aurélien Aptel (graphics & drums)\
 - Pierre Lulé (code)\
 - Frédéric Poussigue (guitar)",200,550,300, 'left')
	
   love.graphics.printf("Framework : LÖVE (love2d.org)\
Libraries :\
 - Quickie by vrld\
 - hump by vrld\
 - AnAL by bartbes\
 - tween.lua by kikito",600,550,Width-500, 'left')
end
