Class = require 'hump.class'

local Level = Class
{	name = "Level",
	function(self, x, y, level, scale)
		self.sizeX = 1024
		self.sizeY = 768
		self.x = x
		self.y = y
		self.scale = scale or 1 -- STABLE
		self.level = level
	end
}

function Level:draw()
	love.graphics.setColor(self.level*100, self.level*100, self.level*100)
	local sizeX,sizeY = self.sizeX*self.scale, self.sizeY*self.scale
	local x = self.x-sizeX/2
	local y = self.y-sizeY/2

	love.graphics.rectangle("fill", x, y, sizeX, sizeY)
	love.graphics.setColor(255,0,0)
	love.graphics.setLine(2, "smooth")
	love.graphics.rectangle("line", x, y, sizeX, sizeY)
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

return Level
