Class = require 'hump.class'
Box = require 'box'
Camera = require 'hump.camera'

Level = Class
{	name = "Level",
	function(self, x, y, level, scale)
		self.sizeX = 1024
		self.sizeY = 768
		self.x = x
		self.y = y
		self.scale = scale or 1 -- STABLE
		self.level = level
		self.boxes = {} -- Ne pas générer les boxes ici !
		self.frontRain = {}
		local frontRain = self.frontRain
	end
}

function Level:draw(background)
	love.graphics.setColor(self.level*100, self.level*100, self.level*100)
	local sizeX,sizeY = self.sizeX*self.scale, self.sizeY*self.scale
	local x = self.x
	local y = self.y

	love.graphics.setColor(255,255,255)
	if background then
		love.graphics.draw(game.Background,x,y,0,self.scale,self.scale)
	end
	game.desaturate:send("desaturation_factor",self.level/10)
	love.graphics.setPixelEffect(game.desaturate)
	love.graphics.draw(game.Batiment,x+250*self.scale,y+103*self.scale,0,self.scale,self.scale)
	love.graphics.setPixelEffect()

	love.graphics.push()
	love.graphics.translate(x,y)
	love.graphics.scale(self.scale,self.scale)
	for i,box in ipairs(self.boxes) do
--		love.graphics.setPixelEffect(game.desaturate)
		box:draw(i)
	end
--	love.graphics.setPixelEffect()
	love.graphics.setLine(2,'smooth')
	love.graphics.setColor(200,200,255,255)
	for _,rain in pairs(self.frontRain) do
		love.graphics.line(rain.x+(rain.y*rainSlope/Width),rain.y,
						   rain.x+((rain.y+rainSize)*rainSlope/Width),rain.y+rainSize)
	end
--	for i=0,Width-100 do
--		if(math.random()<0.0005) then
--			love.graphics.line(i,0,i+100,Height)
--		end
--	end
	love.graphics.pop()
end

function Level:setPosition(x,y)
	self.x,self.y = x,y
end

function Level:getPosition()
	return self.x,self.y
end

function Level:setScale(scale)
	self.scale = scale
end

function Level:generateBoxes()
	self.boxes = {}
	local boxes = self.boxes
	local y = boxStartY
	for i=1,nBoxesY do
		local x = boxStartX
		for j=1,nBoxesX do
			table.insert(boxes, Box(x,y,boxSizeX,boxSizeY,'type',self.level+1,screenFactor))
			x = x + boxSizeX + boxSpaceX
		end
		y = y + boxSizeY + boxSpaceY
	end
	self.rainGen = Timer.addPeriodic(
		0.01, function()
			table.insert(self.frontRain,{x=math.random(0,Width-100),y=-rainSize})
		   end)
end

function Level:boxUnder(x,y)
	local underbox = nil
	for _,box in ipairs(self.boxes) do
		if(box:isClicked(x,y)) then
			underbox = box
			dbg("A box is clicked")
		end
	end
	return underbox
end

function Level:update(dt)
	for i,rain in pairs(self.frontRain) do
		rain.y = rain.y+dt*rainSpeed
		if rain.y+rainSize/2 > Height then
			self.frontRain[i] = nil
		end
	end
end

return Level
