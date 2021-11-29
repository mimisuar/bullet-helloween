weapOrb = class("weapOrb", enemy)
weapOrb.img = {}
weapOrb.img[witchWeap.skele] = love.graphics.newImage("images/skeleweap.png")
weapOrb.img[witchWeap.corn] = love.graphics.newImage("images/cornweap.png")

function weapOrb.init(this)
	this.x = 0
	this.y = 0
	this.weap = witchWeap.magic
	this.hspeed = 5 * 60
	
	this.box = bbox(this.x, this.y, 40, 40)
end

function weapOrb.update(this, dt)
	this.x = this.x - this.hspeed * dt
	
	this.box:move(this.x, this.y)
	
	if this.x < 0 then
		this.destroy = true
	end
end

function weapOrb.draw(this)
	love.graphics.draw(this.img[this.weap], this.x, this.y)
end

function weapOrb.collide(this)

end