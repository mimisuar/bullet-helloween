bbox = class("bbox")

function bbox:init(x, y, w, h)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
end

function bbox:move(x, y)
	self.x = x
	self.y = y
end

function bbox:resize(w, h)
	self.w = w
	self.h = h
end

function bbox:collides(other)
	
	if not other then
		return false
	end
	
	local myLeft,myTop,myRight,myBottom
	myLeft = x or self.x
	myTop = y or self.y
	myRight = myLeft+self.w
	myBottom = myTop+self.h
	
	local oLeft,oTop,oRight,oBottom
	oLeft = other.x
	oTop = other.y
	oRight = other.x+other.w
	oBottom = other.y+other.h
	
	if myLeft >= oRight then
		return false
	end
	
	if myRight <= oLeft then
		return false
	end
	
	if myTop >= oBottom then
		return false
	end
	
	if myBottom <= oTop then
		return false
	end
	
	-- what even is this --
	return ((myLeft >= oLeft and myLeft <= myRight) or (oLeft >= myLeft and oLeft <= myRight)) and ((myTop >= oTop and myTop <= oBottom) or (oTop >= myTop and oTop <= myBottom))
end

function bbox:draw(color)
	love.graphics.setColor(color or {255, 255, 255})
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	love.graphics.setColor(255, 255, 255)
end