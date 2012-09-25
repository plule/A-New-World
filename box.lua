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
	  self.dx = dx
	  self.dy = dy
	  self.level = Level(dx, dy, level, screenFactor)
	  self.gratteTimer = nil
  end
}

function Box:getPosition()
	return self.x,self.y
end

function Box:draw(i)
	local x = self.x
	local y = self.y
	local sizeX,sizeY = self.sizeX, self.sizeY
	game.desaturate:send("desaturation_factor",self.level.level/10)
	love.graphics.setPixelEffect(game.desaturate)
	
	if(self.type == 'boss' or self.type == 'jumping' or self.type == 'empty') then
		love.graphics.draw(BourseMiniature[BourseLevel[self.level.level+1]],self.dx,self.dy,0,boxSizeX/400,boxSizeY/400)		
	else
		love.graphics.draw(game.Miniature,self.dx,self.dy,0,boxSizeX/400,boxSizeY/400)
	end
	love.graphics.setPixelEffect()
	if(self.level == game.nextLevel) then
		self.level:draw(true)
	end
	game.desaturate:send("desaturation_factor",self.level.level/10)
	love.graphics.setPixelEffect(game.desaturate)
	if(self.type == 'normal') then
		if(self.gratteTimer) then
			game.GrattePics[i]:draw(x,y,0,boxSizeX/400, boxSizeY/400)
		else
			game.CasePics[i]:draw(x,y,0,boxSizeX/400, boxSizeY/400)
		end
		love.graphics.setPixelEffect()
	elseif(self.type == 'hippie') then
		game.HippiePics[i]:draw(x,y,0,boxSizeX/400, boxSizeY/400)
	elseif(self.type == 'boss') then
		game.Boss:draw(x,y,0,boxSizeX/400, boxSizeY/400)
	elseif(self.type == 'jumping') then
		game.JumpBoss:draw(x,y,0,boxSizeX/400, boxSizeY/400)
	elseif(self.type == 'empty') then
		love.graphics.draw(game.BossVide,x,y,0,boxSizeX/400, boxSizeY/400)
	end
end

function Box:isClicked(x,y)
	-- dbg("Box clicked?")
	-- dbg("x "..x.." y "..y)
	-- dbg("x "..self.x.." y "..self.y)
	return x >= self.x - self.sizeX/2 and x <= self.x + self.sizeX/2 and
		y >= self.y - self.sizeY/2 and y <= self.y + self.sizeY/2
end

function Box:gratte(nBox)
	if not self.gratteTimer then
		game.GrattePics[nBox]:reset()
		game.GrattePics[nBox]:play()
		self.gratteTimer = Timer.add(3, function() self.gratteTimer = nil end)
	end
end

function Box:setLevel(level)
	self.level.level = level
end

return Box
