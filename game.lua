Camera = require 'hump.camera'
Level = require 'level'
--Box = require 'box'
local tween = require 'tween.tween'

game = Gamestate.new()

function game:init()
	self.Background = love.graphics.newImage('pics/back01_avec_bat.jpg')
	self.Case = love.graphics.newImage('pics/casetest.jpg')

	nBoxesX = 6
	nBoxesY = 6
	boxSizeX = 50
	boxSizeY = 50
	boxSpaceX = 25
	boxSpaceY = 25
	boxStartX = 300+boxSizeX/2
	boxStartY = 153+boxSizeY/2
	
	boxFactor = Width/self.Case:getWidth()
	screenFactor = 0.0185
end

function game:enter()
	self.camera = Camera(Width/2,Height/2, 1, 0)
	self.level = Level(Width/2, Height/2, 0)
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
		self.camera.zoom=1
		self.camera.x, self.camera.y = Width/2, Height/2
		self.level = self.nextLevel
		self.level:setScale(1)
		self.level:setPosition(Width/2,Height/2)
--		self.box = Box(100, 100, 'type', self.box.level.level+1 , screenFactor)
		self.nextLevel = nil
	end
end

function game:draw()
	self.camera:attach()
	self.level:draw()
--	self.box:draw()
	if self.nextLevel then
		self.nextLevel:draw()
	end
	self.camera:detach()
	love.graphics.print("A New World", 10, 10)
end

function game:switchToNextLevel(box)
	dbg("Switching to next level")
	self.nextLevel = box.level
	self.nextLevel:generateBoxes()
	if not self.switching then
		self.switching = true
		local destX,destY = self.nextLevel:getPosition()
		self.moveTween = tween(3, self.camera, {x=destX,y=destY}, 'outCubic',
							   function()
								   self.moveTween = nil
							   end)
		self.zoomTween = tween(3, self.camera, {zoom=1/screenFactor}, 'inCubic',
							   function()
								   self.zoomTween = nil
							   end)
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
