Gamestate = require 'hump.gamestate'
game = require 'game'
require 'music'
Timer = require 'hump.timer'
require 'menu'

function dbg(...)
--	print("[debug]",...)
end

function love.load()
	Height = love.graphics.getHeight()
	Width = love.graphics.getWidth()
	Music:load()
	Font = love.graphics.newFont('profaisal-eliteriqav1-0/Profaisal-EliteRiqaV1.0.ttf',50)
	SmallFont = love.graphics.newFont('profaisal-eliteriqav1-0/Profaisal-EliteRiqaV1.0.ttf',20)
	MenuFont = love.graphics.newFont('profaisal-eliteriqav1-0/Profaisal-EliteRiqaV1.0.ttf',30)
	Gamestate.switch(menu)
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
	Gamestate.mousereleased(x,y,button)
end
