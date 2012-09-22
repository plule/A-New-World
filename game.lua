--Camera = require 'hump.camera'
Level = require 'level'
--Box = require 'box'
local tween = require 'tween.tween'

local game = Gamestate.new()

function game:init()
end

function game:enter()
--	self.camera = Camera(Width/2,Height/2, 1, 0)
	self.camera = {x=0,y=0,scale=1}
	self.level = Level(0, 0, 0)
	self.level:generateBoxes()
	self.nextLevel = nil

--	self.box = Box(100, 100, 'type', 1, game.screenFactor)m
	self.switching = false
	self.zoomTween = nil
	self.moveTween = nil
end

function game:generateLevel(level)

end

function game:update(dt)
	tween.update(dt)
	if(self.switching and not self.zoomTween and not self.moveTween) then
		self.switching = false
		self.camera.scale=1
		self.camera.x, self.camera.y = 0,0
		self.level = self.nextLevel
		self.level:setScale(1)
		self.level:setPosition(0,0)
		self.nextLevel = nil
	end
end

function game:draw()
--	self.camera:attach()
	love.graphics.push()
	love.graphics.translate(self.camera.x, self.camera.y)
	love.graphics.scale(self.camera.scale, self.camera.scale)
	self.level:draw()
--	self.box:draw()
	if self.nextLevel then
		self.nextLevel:draw()
	end
	love.graphics.pop()
--	self.camera:detach()
	love.graphics.print("A New World", 10, 10)
end

function game:switchToNextLevel(box)
	dbg("Switching to next level")
	self.nextLevel = box.level
	self.nextLevel:generateBoxes()
	if not self.switching then
		self.switching = true
		local destX,destY = self.nextLevel:getPosition()
		destX = -destX + Width/2
		destY = -destY + Height/2
		self.moveTween = tween(3, self.camera, {x=destX,y=destY}, 'outCubic',
							   function()
								   self.moveTween = nil
							   end)
--		self.zoomTween = tween(3, self.camera, {scale=1/screenFactor}, 'inCubic',
--							   function()
--								   self.zoomTween = nil
--							   end)
	end
end

function game:mousepressed(x,y)
	local clickedBox =  self.level:boxUnder(x,y)
	if(clickedBox) then
		self:switchToNextLevel(clickedBox)
	end
--	if self.box:isClicked(x,y) then
--		self:switchToNextLevel(self.box)
--	end
end

return game
