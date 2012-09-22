Class = require 'hump.class'
Box = require 'box'

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
	love.graphics.push()
	love.graphics.scale(self.scale)
	for _,box in ipairs(self.boxes) do
		box:draw()
	end
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

return Level
