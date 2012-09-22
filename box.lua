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

	  local sx = self.sizeX/400--game.Case:getWidth()
	  local sy = self.sizeY/400--game.Case:getHeight()
	  local dx = x + sx*202
	  local dy = y + sy*111
	  self.level = Level(dx, dy, level, screenFactor)
  end
}

function Box:draw(i)
	local x = self.x
	local y = self.y
	local sizeX,sizeY = self.sizeX, self.sizeY
	game.CasePics[i]:draw(x,y,0,boxSizeX/400, boxSizeY/400)
--	self.level:draw(true)
end

function Box:isClicked(x,y)
	-- dbg("Box clicked?")
	-- dbg("x "..x.." y "..y)
	-- dbg("x "..self.x.." y "..self.y)
	return x >= self.x - self.sizeX/2 and x <= self.x + self.sizeX/2 and
		y >= self.y - self.sizeY/2 and y <= self.y + self.sizeY/2
end

return Box
