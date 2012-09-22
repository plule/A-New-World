Gamestate = require 'hump.gamestate'
game = require 'game'

function love.load()
	Height = love.graphics.getHeight()
	Width = love.graphics.getWidth()
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
