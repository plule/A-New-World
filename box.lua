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
--	love.graphics.draw(game.Case, x,y, 0, boxSizeX/game.Case:getWidth(), boxSizeY/game.Case:getHeight())
	game.CasePics[i]:draw(x,y,0,boxSizeX/400, boxSizeY/400)
--	love.graphics.setColor(255,255,255)
--	love.graphics.rectangle("fill", x, y, sizeX, sizeY)
--	love.graphics.setColor(0,255,0)
--	love.graphics.setLine(2, "smooth")
--	love.graphics.rectangle("line", x, y, sizeX, sizeY)
	self.level:draw()
end

function Box:isClicked(x,y)
	-- dbg("Box clicked?")
	-- dbg("x "..x.." y "..y)
	-- dbg("x "..self.x.." y "..self.y)
	return x >= self.x - self.sizeX/2 and x <= self.x + self.sizeX/2 and
		y >= self.y - self.sizeY/2 and y <= self.y + self.sizeY/2
end

return Box
