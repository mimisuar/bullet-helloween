local skele = class("enemy.skele", enemy)
skele.img = love.graphics.newImage("images/skele.png")
skele.width = 80
skele.height = 80
skele.limit = 80
skele.quads = {}
for i=1, 2 do
	i = i - 1
	table.insert(skele.quads, love.graphics.newQuad(i * skele.width, 0, skele.width, skele.height, skele.img:getWidth(), skele.img:getHeight()))
end

function skele.init(this)
	this.x = screen:getWidth() + this.width + 4
	this.startY = math.random(0, screen:getHeight() - this.height)
	this.y = startY
	
	this.attackPow = 2
	this.box = bbox(this.x, this.y, 80, 80)
	this.frame = 1
	this.frametime = 0
	this.updatetime = 0.1
	
	this.flicker = 0
	this.flickerTimer = 0
	this.flickerTime = 0.1
	
	this.fallSpeed = 6 * 60
	this.yspeed = 0
	this.xspeed = 6 * 60
	
	this.damage = 1
	this.health = 2
end

function skele.update(this, dt)
	this.x = this.x - this.xspeed * dt
	
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
		this.y = math.floor((math.sin(this.x)) * 80 + this.startY)
	end
	
	this.frametime = this.frametime + dt
	if this.frametime > this.updatetime then
		this.frametime = 0
		this.frame = this.frame == 1 and 2 or 1
	end
	
	
	
	this.box:move(this.x, this.y)
	
	if this.x < -this.width and not this.dead then
		this.destroy = true
	end
	
	if this.health <= 0 and not this.dead then
		this.dead = true
		
		if math.random(1, 10) == 1 then
			local orb = weapOrb()
			orb.x = this.x
			orb.y = this.y
			orb.weap = witchWeap.skele
			
			table.insert(game.enemies, orb)
		end
		
		game.score = game.score + 500
	end
end

function skele.draw(this)
	if this.flicker % 2 == 0 then
		
		love.graphics.draw(this.img, this.quads[this.frame], math.floor(this.x), math.floor(this.y))
	end
end

function skele.collide(this, other)
	if this.dead then
		return
	end
	
	if other.name and other.name:find("witchWeap") and this.flicker == 0 then
		this.flicker = 3
		
		if other.name:find("magic") then
			this.health = this.health - 2
			
			enemy.painSound:stop()
			enemy.painSound:play()
			
			other.destroy = true
		elseif other.name:find("skele") then
			this.health = this.health
			this.flicker = 0
			this.xspeed = this.xspeed + 60
			--enemy.painSound:stop()
			--enemy.painSound:play()
		elseif other.name:find("corn") then
			this.health = this.health - 2
			
			enemy.painSound:stop()
			enemy.painSound:play()
		end
	end
end


table.insert(enemy.types, skele)

-- osc: y = sin(x) * limit + starty