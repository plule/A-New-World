Class = require 'hump.class'

--Level = require 'level'

local Box = Class
{ name = "Box",
  function(self, x, y, sizeX, sizeY, type, level)
	  self.sizeX = sizeX
	  self.sizeY = sizeY
	  self.x = x
	  self.y = y
	  self.type = type
	  self.level = Level(x-5, y-5, level, screenFactor)
  end
}

function Box:draw()
	local x = self.x-self.sizeX/2
	local y = self.y-self.sizeY/2
	local sizeX,sizeY = self.sizeX, self.sizeY
	
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("fill", x, y, sizeX, sizeY)
	love.graphics.setColor(0,255,0)
	love.graphics.setLine(2, "smooth")
	love.graphics.rectangle("line", x, y, sizeX, sizeY)
--	self.level:draw()
end

function Box:isClicked(x,y)
	-- dbg("Box clicked?")
	-- dbg("x "..x.." y "..y)
	-- dbg("x "..self.x.." y "..self.y)
	return x >= self.x - self.sizeX/2 and x <= self.x + self.sizeX/2 and
		y >= self.y - self.sizeY/2 and y <= self.y + self.sizeY/2
end

return Box
