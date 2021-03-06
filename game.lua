Camera = require 'hump.camera'
Level = require 'level'
local tween = require 'tween.tween'
require("AnAL")

game = Gamestate.new()

function game:init()
	nBoxesX = 6
	nBoxesY = 6
	self.Background = love.graphics.newImage('pics/back01.jpg')
	self.Batiment = love.graphics.newImage('pics/bat.jpg')
	self.Miniature = love.graphics.newImage('pics/miniature.png')
	self.volume = 1

	BourseMiniature = {}
	for i=1,5 do
		table.insert(BourseMiniature,love.graphics.newImage('pics/miniature-bourse-'..i..'.png'))
	end

	BourseLevel = {1,1,2,2,3,3,4,5}

--	self.BourseMiniature = love.graphics.newImage('pics/miniature-bourse.png')
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

	self.Space = love.graphics.newImage('pics/space.jpg')

	local jumpBossPic = love.graphics.newImage('pics/boss-jump.png')
	self.JumpBoss = newAnimation(jumpBossPic, 400, 400, 0.2, 0)
	self.JumpBoss:setDelay(2,2)
--	self.JumpBoss:setMode('once')

	self.BossVide = love.graphics.newImage('pics/boss-vide.png')

	local BossBallPic = love.graphics.newImage('pics/boss-ball.png')
	self.BossBall = newAnimation(BossBallPic, 400, 400, 0.2, 0)

	self.desaturate = love.graphics.newPixelEffect(love.filesystem.read('desaturate.frag'))

	EndMusic = love.audio.newSource('snd/end.ogg','stream')
	SpaceMusic = love.audio.newSource('snd/space.ogg','stream')

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
		3,
		4,
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
	self.level = Level(0,0, 1)
	self.level:generateBoxes()
	self.nextLevel = nil

	self.switching = false
	self.zoomTween = nil
	self.moveTween = nil

	self.printBoss = false
	self.boss = {x=Width/2,y=Height/2,scale=1}
	Music:start()
end

function game:update(dt)
	love.audio.setVolume(self.volume)
	Timer.update(dt)
	self.Boss:update(dt)
	self.JumpBoss:update(dt)
	self.BossBall:update(dt)
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
		Timer.cancelPeriodic(self.level.rainGen)
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
		if(self.isEnding) then
			love.graphics.setColor(math.random(0,255),math.random(0,255),math.random(0,255))
		end
		love.graphics.draw(self.Background,0,0)
	end
	self.level:draw(false)
	if(self.drawSpace) then
		love.graphics.draw(self.Space,0,Height)
	end
	self.camera:detach()
	if(self.printBoss) then
		love.graphics.setColor(255,255,255)
		self.BossBall:draw(self.boss.x, self.boss.y,-self.camera.rot,self.boss.scale,self.boss.scale,200,200)
	end
	if(self.credit) then
		love.graphics.setFont(Font)
		love.graphics.setColor(math.random(0,255),math.random(0,255),math.random(0,255))
		love.graphics.printf("A New World", 0, 250, Width, 'center')
		love.graphics.setFont(SmallFont)
		love.graphics.printf("A Game by\
Aurélien Aptel (graphics & drums)\
Pierre Lulé (code)\
Frédéric Poussigue (guitar)", 0, 350, Width, 'center')
	end
	if(self.isEnding) then
--		love.graphics.setColor(math.random(0,255),math.random(0,255),math.random(0,255))
	end
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
	tween(17, self, {volume=0},'linear')
	self.isEnding = true
	self.bossBox = bossBox
	local destX,destY = bossBox.level:getPosition()
	local zoom = boxSizeX/400
	tween(7, self.camera, {x=destX-12,y=destY+10}, 'inOutQuad')
	tween(12, self.camera, {zoom=1/zoom}, 'inOutQuad',
		  function()
			  self:end0()
		  end)
end

function game:end0()
	Timer.add(3, function() self:end1() end)
end

function game:end1()
	self.JumpBoss:reset()
	self.bossBox.type = 'jumping'
	Timer.add(3.35, function()self:end2()end)
end

function game:end2()
	love.audio.stop()
	self.volume = 1
	self.BossBall:reset()
	EndMusic:play()
	self.printBoss = true
	self.bossBox.type = 'empty'
	self.drawSpace = true
	rainSpeed = 300
	Timer.setDelay(self.level.rainGen, 0.1)
	tween(20, self.camera, {y = Height}, 'linear', function()self:end3()end)
end

function game:end3()
	SpaceMusic:play()
	tween(3, self.camera, {x = Width/2, zoom = 1, rot = math.pi}, 'inOutQuad')
	tween(3, self.boss, {scale = 0.5}, 'inOutQuad')
	tween(3, self.camera, {y = Height + 100}, 'inQuad', function()self:end4()end)
end

function game:end4()
	tween(20, self.camera, {y = Height + 1536}, 'linear', function()self:end5()end)
end

function game:end5()
	tween(8, self.boss, {y = Height/2 - 200, scale = 0}, 'outCirc', function()self.credit=true end)
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
