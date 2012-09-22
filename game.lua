Camera = require 'hump.camera'
Level = require 'level'
--Box = require 'box'
local tween = require 'tween.tween'
require("AnAL")

game = Gamestate.new()

function game:init()
	nBoxesX = 6
	nBoxesY = 6
	self.Background = love.graphics.newImage('pics/back01.jpg')
	self.Batiment = love.graphics.newImage('pics/batcool.jpg')
	local casePic = love.graphics.newImage('pics/casetest.jpg')
	self.CasePics = {}
	for i = 1,nBoxesX*nBoxesY do
		local case = newAnimation(casePic, 400, 400, 0.2, 0)
		case:update(math.random())
		table.insert(self.CasePics,case)
	end
	self.Case = newAnimation(casePic, 400, 400, 0.2, 0)
	self.Case:setMode("loop")
	boxSizeX = 50
	boxSizeY = 50
	boxSpaceX = 25
	boxSpaceY = 25
	boxStartX = 300
	boxStartY = 153
	
	boxFactor = Height/casePic:getHeight()
	screenFactor = 0.0185
end

function game:enter()
	self.camera = Camera(Width/2,Height/2, 1, 0)
	self.level = Level(0,0, 0)
	self.level:generateBoxes()
	self.nextLevel = nil

	self.switching = false
	self.zoomTween = nil
	self.moveTween = nil
end

function game:generateLevel(level)

end

function game:update(dt)
	for _,case in ipairs(self.CasePics) do
		case:update(dt)
	end
	tween.update(dt)
	if(self.switching and not self.zoomTween and not self.moveTween) then
		self.switching = false
		self.camera.zoom=1
		self.camera.x, self.camera.y = Width/2,Height/2
		self.level = self.nextLevel
		self.level:setScale(1)
		self.level:setPosition(0,0)
		self.nextLevel = nil
	end
end

function game:draw()
	love.graphics.draw(self.Background,0,0)
	self.camera:attach()
	self.level:draw(false)
	if self.nextLevel then
		self.nextLevel:draw(true)
	end
	self.camera:detach()
	love.graphics.print("A New World", 10, 10)
end

function game:switchToNextLevel(box)
	dbg("Switching to next level")
	self.nextLevel = box.level
	self.nextLevel:generateBoxes()
	self.switching = true
	local destX,destY = self.nextLevel:getPosition()
	self.moveTween = tween(3, self.camera, {x=destX+screenFactor*Width/2,y=destY+screenFactor*Height/2}, 'outCubic',
						   function()
							   self.moveTween = nil
						   end)
	self.zoomTween = tween(3, self.camera, {zoom=1/screenFactor}, 'inCubic',
						   function()
								   self.zoomTween = nil
						   end)
end

function game:mousepressed(x,y)
	local clickedBox =  self.level:boxUnder(x-boxSizeX/2,y-boxSizeY/2)
	if(clickedBox and not self.switching) then
		self:switchToNextLevel(clickedBox)
	end
end

return game
