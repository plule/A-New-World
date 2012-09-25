Gamestate = require 'hump.gamestate'
game = require 'game'

function dbg(...)
	print("[debug]",...)
end

function love.load()
	Height = love.graphics.getHeight()
	Width = love.graphics.getWidth()


	screenFactor = 0.02
	nBoxesX = 3
	nBoxesY = 4
	boxSizeX = 50
	boxSizeY = 50
	boxSpaceX = 10
	boxSpaceY = 10
	boxStartX = 30
	boxStartY = 30

	Gamestate.switch(game)
end

function love.draw()
	Gamestate.draw()
end

function love.update(dt)
	if(dt>0) then
		Gamestate.update(dt)
	end
end

function love.keypressed(k)
	if(k == 'escape') then
		love.event.quit()
	else
		Gamestate.keypressed(k)
	end
end

function love.mousepressed(x,y,button)
	Gamestate.mousepressed(x,y,button)
end

function love.mousereleased(x,y,button)
	Gamestate.mousepressed(x,y,button)
end
