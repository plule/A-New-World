Camera = require 'hump.camera'
Level = require 'level'

local game = Gamestate.new()

function game:init()
end

function game:enter()
	self.camera = Camera(Width/2,Height/2, 1, 0)
	self.level = Level(Width/2, Height/2, 0)
	self.nextLevel = Level(100, 100, 1, 0.1)
end

function game:update(dt)
	self.nextLevel:setPosition(love.mouse.getPosition())
end

function game:draw()
	self.camera:attach()
	self.level:draw()
	self.nextLevel:draw()
	self.camera:detach()
	love.graphics.print("A New World", 10, 10)
end

return game
