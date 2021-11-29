witch = class("witch")
witch.image = {}
witch.image.width = 160
witch.image.height = 160
witch.image.frames = {}
for i=1, 2 do
	i = i - 1
	table.insert(witch.image.frames, love.graphics.newQuad(i * witch.image.width, 0, witch.image.width, witch.image.height, witch.image.width * 2, witch.image.height))
end
witch.image.src = love.graphics.newImage("images/witch.png")

witch.painSounds = {}
for i=1, 3 do
	local src = love.audio.newSource("sounds/pain" .. i .. ".ogg")
	src:setVolume(0.5)
	table.insert(witch.painSounds, src)
end

function witch.init(this)
	this.x = -this.image.width
	this.y = screen:getHeight() / 2 - this.image.height * 2
	this.ready = false
	this.readySpeed = 2 * 60
	this.flyingSpeed = 8 * 60
	this.frame = 1
	this.frametime = 0
	this.updatetime = 0.1
	this.canfire = 0
	this.weapon = witchWeap.magic()
	this.box = bbox(this.x, this.y, 80, 80)
	this.flicker = 0
	this.flickerTimer = 0
	this.flickerTime = 0.1
	
	
	this.healtime = 0
	this.healtimer = 0.5
	
	this.health = 18
	this.maxHealth = this.health
end

function witch.update(this, dt)
	if game.furymode then
		this.health = this.maxHealth
	end
	
	if this.flicker > 0 then
		this.flickerTimer = this.flickerTimer + dt
		if this.flickerTimer > this.flickerTime then
			this.flickerTimer = 0
			this.flicker = this.flicker - 1
		end
	else
		this.healtime = this.healtime + dt
		if this.healtime > this.healtimer then
			this.healtime = 0
			this.health = this.health + 1
			if this.health > this.maxHealth then
				this.health = this.maxHealth
			end
		end
	end
	
	if this.dead then
		if this.flicker <= 0 then
			this.flicker = 5
		end
		
		this.paused = false
		this.y = this.y + this.flyingSpeed * dt
		this.x = this.x + this.flyingSpeed * dt
		
		if this.y < screen:getHeight() then
			shake = 0.5
		end
		
		return
	end
	
	if not this.paused then
		this.canfire = this.canfire - dt
		
		if this.canfire < 0 then
			this.canfire = 0
		end
		
		this.weapon:update(dt)
		
		if this.weapon.ammo and this.weapon.ammo <= 0 then
			this.weapon = witchWeap.magic()
		end
		
		this.frametime = this.frametime + dt
		
		if this.frametime > 0.1 then
			this.frametime = 0
			this.frame = this.frame + 1
			if this.frame > #this.image.frames then
				this.frame = 1
			end
		end
		
		if not this.ready then
			this.x = this.x + this.readySpeed * dt
			this.y = this.y + this.readySpeed * dt
			
			
			if this.x > 80 then
				this.ready = true
				this.y = screen:getHeight() / 2 - this.image.height / 2
			end
			
			if this.y > screen:getHeight() / 2 - this.image.height / 2 then
				this.y = screen:getHeight() / 2 - this.image.height / 2
			end
		else
			-- ready to start flying --
			
			if love.keyboard.isDown("right") then
				this.x = this.x + this.flyingSpeed * dt
				if this.x > screen:getWidth() - this.image.width / 2 then
					this.x = screen:getWidth() - this.image.width / 2
				end
			elseif love.keyboard.isDown("left") then
				this.x = this.x - this.flyingSpeed * dt
				if this.x < 0 then
					this.x = 0
				end
			end
			if love.keyboard.isDown("down") then
				this.y = this.y + this.flyingSpeed * dt
				if this.y > screen:getHeight() - this.image.height / 2 then
					this.y = screen:getHeight() - this.image.height / 2
				end
			elseif love.keyboard.isDown("up") then
				this.y = this.y - this.flyingSpeed * dt
				if this.y < 0 then
					this.y = 0
				end
			end
			
			if love.keyboard.isDown("s") and this.canfire == 0 then
				this.canfire = this.canfire + this.weapon:fire() or 1
			end
		end
	end
	
	
	
	this.box:move(this.x, this.y)
	
	this:collisions()
end

function witch.draw(this)
	if not this.dead then
		this.weapon:draw()
	end
	
	
	if this.flicker % 2 == 0 then
		
		
		love.graphics.draw(this.image.src, this.image.frames[this.frame], math.floor(this.x), math.floor(this.y), 0, 0.5, 0.5)
		
	end
end

function witch.collisions(this)
	for i=1, #game.enemies do
		if this.box:collides(game.enemies[i].box) then
			-- handle collisions appropriately --
			this:collideWithEnemy(game.enemies[i])
			game.enemies[i]:collide(this)
		end
		
		for j=1, #this.weapon.projs do
			if this.weapon.projs[j] and this.weapon.projs[j].box:collides(game.enemies[i].box) then
				game.enemies[i]:collide(this.weapon.projs[j])
			end
		end
	end
end

function witch.collideWithEnemy(this, enemy) 
	
	if enemy.class.name == "weapOrb" then
		enemy.destroy = true
		this.weapon = enemy.weap()
		return
	end
	
	if this.flicker > 0 or enemy.dead then
		return
	end
	
	if this.dead then
		return
	end
	
	this.painSounds[math.random(1, #this.painSounds)]:play()
	
	this.flicker = 5
	shake = shake + 0.25
	
	this.health = this.health - enemy.damage
	
	if this.health <= 0 then
		this.dead = true
	end
end