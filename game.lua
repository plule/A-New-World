Camera = require 'hump.camera'
Level = require 'level'
local tween = require 'tween.tween'

local game = Gamestate.new()

game.screenFactor = 0.1

function game:init()
end

function game:enter()
	self.camera = Camera(Width/2,Height/2, 1, 0)
	self.level = Level(Width/2, Height/2, 0)
	self.nextLevel = nil--Level(100, 100, 1, self.screenFactor)
	self.switching = false
	self.zoomTween = nil
	self.moveTween = nil
end

function game:update(dt)
	tween.update(dt)
	if(self.switching and not self.zoomTween and not self.moveTween) then
		self.switching = false
		self.camera.zoom=1
		self.camera.x, self.camera.y = Width/2, Height/2
		self.level = self.nextLevel
		self.level:setScale(1)
		self.level:setPosition(Width/2,Height/2)
		self.nextLevel = nil
	end
--	self.nextLevel:setPosition(love.mouse.getPosition())
end

function game:draw()
	self.camera:attach()
	self.level:draw()
	if self.nextLevel then
		self.nextLevel:draw()
	end
	self.camera:detach()
	love.graphics.print("A New World", 10, 10)
end

function game:switchToNextLevel()
	if not self.switching then
		self.switching = true
		local destX,destY = self.nextLevel:getPosition()
		self.moveTween = tween(3, self.camera, {x=destX,y=destY}, 'outCubic',
							   function()
								   self.moveTween = nil
							   end)
		self.zoomTween = tween(3, self.camera, {zoom=1/self.screenFactor}, 'inCubic',
							   function()
								   self.zoomTween = nil
							   end)
	end
end

function game:keypressed(k)
	self.nextLevel = Level(100, 100, self.level.level+1, self.screenFactor)
	self:switchToNextLevel()
end

return game
