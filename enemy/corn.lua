local corn = class("enemy.corn", enemy)
corn.img = love.graphics.newImage("images/corn.png")
corn.width = 40
corn.height = 40
corn.quads = {}
for i=1, 2 do
	i = i - 1
	table.insert(corn.quads, love.graphics.newQuad(i * 40, 0, 40, 40, 80, 40))
end

local cornWeap = require("enemy.cornWeap")

function corn.init(this)
	this.x = screen:getWidth() + this.width + 4
	this.y = math.random(0, screen:getHeight() - this.height)
	
	this.speed = math.random(2, 5) * 60
	this.yspeed = 0
	
	this.frametime = 0
	this.updatetime = 0.1
	this.frame = 1
	this.box = bbox(this.x, this.y, 40, 40)
	
	this.health = 8
	
	this.flicker = 0
	this.flickerTimer = 0
	this.flickerTime = 0.1
	
	this.fallSpeed = 6 * 60
	
	this.projs  = {}
	
	this.attacktime = 0.0
	this.attacktimer = 2.0
	
	this.damage = 4
end

function corn.update(this, dt)
	this.x = this.x - this.speed * dt
	
	if this.flicker > 0 then
		this.flickerTimer = this.flickerTimer + dt
		if this.flickerTimer > this.flickerTime then
			this.flickerTimer = 0
			this.flicker = this.flicker - 1
		end 
	elseif this.dead then
		this.flicker = 1
	end
	
	if this.dead then
		
		this.y = this.y + this.fallSpeed * dt
		
		if this.y > screen:getHeight() then
			this.destroy = true
			
			shake = shake + 0.5
			boomSound:stop()
			boomSound:play()
			
			
			return
		end 
		
		return
	else
		this.y = this.y + this.yspeed * dt
	end
	
	this.frametime = this.frametime + dt
	if this.frametime > this.updatetime then
		this.frametime = 0
		this.frame = this.frame == 1 and 2 or 1
	end
	
	
	if game.witch.y > this.y then
		this.yspeed = math.random(0, 4) * 60
	elseif game.witch.y < this.y then
		this.yspeed = -math.random(0, 4) * 60
	end
	
	this.attacktime = this.attacktime + dt
	if this.attacktime > this.attacktimer then
		this.attacktime = 0
		local proj = cornWeap()
		proj.x = this.x
		proj.y = this.y
		table.insert(game.enemies, proj)
	end
	
	
	this.box:move(this.x, this.y)
	
	if this.x < -this.width and not this.dead then
		this.destroy = true
	end
	
	if this.health <= 0 then
		this.dead = true
		game.score = game.score + 1000
		
		if math.random(1, 3) == 1 then
			local orb = weapOrb()
			orb.weap = witchWeap.corn
			orb.x = this.x
			orb.y = this.y
			table.insert(game.enemies, orb)
		end
	end
end

function corn.draw(this)
	
	
	if this.flicker % 2 == 0 then
		love.graphics.draw(this.img, this.quads[this.frame], this.x, this.y)
	end
end

function corn.collide(this, other)
	if this.dead then
		return
	end
	
	if other.name and other.name:find("witchWeap") and this.flicker == 0 then
		this.flicker = 3
		
		if other.name:find("magic") then
			this.health = this.health - 1
			
			enemy.painSound:stop()
			enemy.painSound:play()
			
			other.destroy = true
		elseif other.name:find("skele") then
			this.health = this.health - 2
			
			enemy.painSound:stop()
			enemy.painSound:play()
		elseif other.name:find("corn") then
			this.health = this.health - 8
			
			enemy.painSound:stop()
			enemy.painSound:play()
		end
	end
end

table.insert(enemy.types, corn)