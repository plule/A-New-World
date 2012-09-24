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
	gui.group.push{spacing = 5, grow = "down", size = {500,25}}
	love.graphics.setFont(SmallFont)
	gui.Label{text = "Controls : mouse & clic. This game has an ending"}
	gui.Label{text = ""}
	gui.Label{text = "A game by"}
	gui.Label{text = " - Aurélien Aptel (graphics & drums)\
 - Pierre Lulé (code)\
 - Frédéric Poussigue (guitar)"}
--	gui.Label{text = "Escape to quit"}
	gui.group.pop{}
	gui.group.pop{}
end

function menu:draw()
	gui.core.draw()
end


function menu:keypressed(key, code)
    gui.keyboard.pressed(key, code)
end
