Camera = require 'hump.camera'
Level = require 'level'
Timer = require 'hump.timer'
--Box = require 'box'
local tween = require 'tween.tween'
require("AnAL")

game = Gamestate.new()

function game:init()
	nBoxesX = 6
	nBoxesY = 6
	self.Background = love.graphics.newImage('pics/back01.jpg')
	self.Batiment = love.graphics.newImage('pics/batcool.jpg')
	self.Miniature = love.graphics.newImage('pics/miniature.png')
	local casePic = love.graphics.newImage('pics/casegrate.png')
	self.CasePics = {}
	for i = 1,nBoxesX*nBoxesY do
		local case = newAnimation(casePic, 400, 400, 0.2, 0)
		case:update(math.random())
		table.insert(self.CasePics,case)
	end
	self.Case = newAnimation(casePic, 400, 400, 0.2, 0)
	self.Case:setMode("loop")

	self.desaturate = love.graphics.newPixelEffect(love.filesystem.read('desaturate.frag'))

	boxSizeX = 50
	boxSizeY = 50
	boxSpaceX = 25
	boxSpaceY = 25
	boxStartX = 300
	boxStartY = 153
	rainSlope = 100
	rainSize = 100
	rainSpeed = 3100
	
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
	self.moveTween = nilb
end

function game:generateLevel(level)

end

function game:update(dt)
	Timer.update(dt)
	for _,case in ipairs(self.CasePics) do
		case:update(dt)
	end
	self.level:update(dt)
	if(self.nextLevel) then
		self.nextLevel:update(dt)
	end
	tween.update(dt)
	if(self.switching and not self.zoomTween and not self.moveTween) then
		self.switching = false
		self.camera.zoom=1
		self.camera.x, self.camera.y = Width/2,Height/2
		Timer.cancel(self.level.rainGen)
		self.level.frontRain = nil
		self.level = nil
		self.level = self.nextLevel
		self.level:setScale(1)
		self.level:setPosition(0,0)
		self.nextLevel = nil
	end
end

function game:draw()
	love.graphics.draw(self.Background,0,0)
	self.camera:attach()
	if self.nextLevel then
		self.nextLevel:draw(true)
	end
	self.level:draw(false)
	self.camera:detach()
	love.graphics.setLine(1,'smooth')
	love.graphics.setColor(255,255,255)

	love.graphics.print("A New World", 10, 10)
end

function game:switchToNextLevel(box)
	dbg("Switching to next level")
	self.nextLevel = box.level
	self.nextLevel:generateBoxes()
	self.switching = true
	local destX,destY = self.nextLevel:getPosition()
	self.moveTween = tween(3, self.camera, {x=destX+screenFactor*Width/2,y=destY+screenFactor*Height/2}, 'outQuint',
						   function()
							   self.moveTween = nil
						   end)
	self.zoomTween = tween(3, self.camera, {zoom=1/screenFactor}, 'inQuad',
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
