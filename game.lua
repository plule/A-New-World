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
	local casePic = love.graphics.newImage('pics/casenormal.png')
	self.CasePics = {}
	for i = 1,nBoxesX*nBoxesY do
		local case = newAnimation(casePic, 400, 400, 0.2, 0)
		case:update(math.random())
		table.insert(self.CasePics,case)
	end

	local grattePic = love.graphics.newImage('pics/casegrate.png')
	self.GrattePics = {}
	for i = 1,nBoxesX*nBoxesY do
		local case = newAnimation(grattePic, 400, 400, 0.2, 0)
		case:setMode('once')
		case:update(math.random()*5)
		table.insert(self.GrattePics,case)
	end

	local HippiePic = love.graphics.newImage('pics/caserelaxA.png')
	self.HippiePics = {}
	for i = 1,nBoxesX*nBoxesY do
		local case = newAnimation(HippiePic, 400, 400, 0.2, 0)
		for i = 1,7 do
			case:addFrame((7-i)*400,0,400,400,0.2)
		end
		case:setDelay(7,3)
		case:setDelay(1,2)

		case:update(math.random()*5)
		table.insert(self.HippiePics,case)
	end

	local BossPic = love.graphics.newImage('pics/boss.png')
	self.Boss = newAnimation(BossPic, 400, 400, 0.2, 0)

	self.BossChar = love.graphics.newImage('pics/bossChar.png')
	self.Space = love.graphics.newImage('pics/space.png')

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
	self.isEnding = false
	game.nbHippie = {
		1,
		2,
		3,
		4,
		6,
		8,
		10,
		15,
		25,
		34
	}

	nbLevels = #game.nbHippie
	
	boxFactor = Height/casePic:getHeight()
	screenFactor = 0.0185

	Timer.addPeriodic(
		0.1,
		function()
			if math.random() < 0.2 then
				local nBox = math.random(1,nBoxesX*nBoxesY)
				self.level:gratte(nBox)
			end
		end)
end

function game:enter()
	self.camera = Camera(Width/2,Height/2, 1, 0)
	self.level = Level(0,0, 10)
	self.level:generateBoxes()
	self.nextLevel = nil

	self.switching = false
	self.zoomTween = nil
	self.moveTween = nilb
end

function game:update(dt)
	Timer.update(dt)
	self.Boss:update(dt)
	for _,case in ipairs(self.CasePics) do
		case:update(dt)
	end
	for _,case in ipairs(self.GrattePics) do
		case:update(dt)
	end
	for _,case in ipairs(self.HippiePics) do
		case:update(dt)
	end
	self.level:update(dt)
	if(self.nextLevel) then
		self.nextLevel:update(dt)
	end
	tween.update(dt)
	if(self.switching and not self.zoomTween and not self.moveTween and not self.ending) then
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
	if(self.drawSpace) then
		love.graphics.draw(self.Background,0,0)
	end
	self.level:draw(false)
--	if self.nextLevel then
--		self.nextLevel:draw(true)
	--	end
	if(self.drawSpace) then
--		love.graphics.setColor(0,0,0)
		--		love.graphics.rectangle("fill",0,Height,1024,200)
		love.graphics.draw(self.Space,0,Height)
	end
	self.camera:detach()
	if(self.boss) then
		love.graphics.setColorMode('replace')
		love.graphics.draw(self.BossChar, Width/2-self.BossChar:getWidth()/2, Height/2-self.BossChar:getHeight()/2)
	end
	love.graphics.setLine(1,'smooth')
	love.graphics.setColor(255,255,255)
--	love.graphics.print("A New World", 10, 10)
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

function game:triggerEnd(bossBox)
	self.isEnding = true
	self.bossBox = bossBox
	local destX,destY = bossBox.level:getPosition()
	local zoom = boxSizeX/400
	tween(5, self.camera, {x=destX,y=destY}, 'outQuint')
	tween(6, self.camera, {zoom=1/zoom}, 'inQuad',
		  function()
			  self:end1()
		  end)
end

function game:end1()
	-- Boss se lève et va vers la fenêtre
	self:end2()
end

function game:end2()
	self.bossBox.type = 'empty'
	self.boss = true
	self.drawSpace = true
	tween(20, self.camera, {y = Height}, 'linear', function()self:end3()end)
end

function game:end3()
	tween(3, self.camera, {x = Width/2, zoom = 1, rot = math.pi}, 'inOutQuad')
	tween(3, self.camera, {y = Height + 100}, 'inQuad', function()self:end4()end)
end

function game:end4()
	tween(20, self.camera, {y = Height + 1536}, 'outQuad')
end

function game:mousepressed(x,y)
	local clickedBox =  self.level:boxUnder(x-boxSizeX/2,y-boxSizeY/2)
	if(clickedBox and not self.switching) then
		if(clickedBox.type == 'boss') then
			self:triggerEnd(clickedBox)
		else
			self:switchToNextLevel(clickedBox)
		end
	end
end

return game
