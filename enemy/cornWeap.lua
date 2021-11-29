local cornWeap = class("enemy.cornWeap", enemy)
cornWeap.img = witchWeap.corn.img
cornWeap.width = 40
cornWeap.height = 40


function cornWeap.init(this)
	this.x = screen:getWidth() + this.width + 4
	this.y = math.random(0, screen:getHeight() - this.height)
	
	this.speed = 5 * 60
	this.yspeed = -6 * 60
	
	this.frametime = 0
	this.updatetime = 0.1
	this.frame = 1
	this.box = bbox(this.x, this.y, 20, 20)
	
	this.flicker = 0
	this.flickerTimer = 0
	this.flickerTime = 0.1
	
	this.fallSpeed = 6
	
	this.damage = 2
	
	this.rot = 0
end

function cornWeap.update(this, dt)
	this.x = this.x - this.speed * dt
	
	this.dead = false
	
	if this.flicker > 0 then
		this.flickerTimer = this.flickerTimer + dt
		if this.flickerTimer > this.flickerTime then
			this.flickerTimer = 0
			this.flicker = this.flicker - 1
		end 
	elseif this.dead then
		this.flicker = 1
	end
	
	this.y = this.y + this.yspeed * dt
	
	this.yspeed = this.yspeed + 12
	
	this.frametime = this.frametime + dt
	if this.frametime > this.updatetime then
		this.frametime = 0
		this.frame = this.frame == 1 and 2 or 1
	end
	
	this.rot = this.rot + dt
	
	this.box:move(this.x, this.y)
	
	if this.x < -this.width and not this.dead then
		this.destroy = true
	end
	
	if this.y > screen:getWidth() then
		this.destroy = true
	end
end

function cornWeap.draw(this)
	
	
	if this.flicker % 2 == 0 then
		love.graphics.draw(this.img, this.x, this.y, math.deg(this.rot), nil, nil, 10, 10)
	end
end

function cornWeap.collide(this, other)
	if this.dead then
		return
	end
end

return cornWeap