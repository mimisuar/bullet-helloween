game = createState()

function game.load(this)
	this.witch = witch()
	this.paused = false
	this.enemies = {}
	this.score = 0
	
	this.enemytime = 0
	this.enemyupdatetime = 0.5
	this.bosstime = 0
	this.bosstime = 2 * 60 -- this is two minutes --
	this.furymode = false
end

function game.update(this, dt)
	this.witch:update(dt)
	
	if this.furymode then
		this.enemyupdatetime = 0.0001
	end
	
	if this.witch.ready then
		this.enemytime = this.enemytime + dt
		if this.enemytime > this.enemyupdatetime then
			this.enemytime = 0
			local max = 0.5
			if this.score > 10000 then
				max = 0.3
			end
			
			if this.score > 20000 then
				max = 0.1
			end
			
			if this.score > 50000 then
				this.enemyupdatetime = 0.05
			else
				this.enemyupdatetime = math.min(math.random(), max)
			end
			
			if not this.witch.dead then
				table.insert(this.enemies, 1, enemy.types[math.random(1, #enemy.types)]())
			end
		end
		
		for i=#this.enemies, 1, -1 do
			
			this.enemies[i]:update(dt)
			
			if this.enemies[i].destroy then
				table.remove(this.enemies, i)
			end
		end
	end
	
	if this.witch.dead and #this.enemies == 0 then
		this:kill()
		titlescreen:load()
		state = titlescreen
	end
end

function game.draw(this)
	this.witch:draw()
	
	for i=1, #this.enemies do
		this.enemies[i]:draw()
	end
	
	local scoretext = string.format("Score: %06d", this.score)
	
	love.graphics.setCanvas()
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(scoretext, 0, 0)
	love.graphics.setColor(255, 255, 255)
	
	local hx, hy, hw, hh = 1, 20, 100, 20
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", hx, hy, hw, hh)
	if this.witch.flicker > 0 then
		love.graphics.setColor(255, 0, 0)
	else
		love.graphics.setColor(0, 255, 0)
	end
	love.graphics.rectangle("line", hx, hy, hw, hh)
	love.graphics.rectangle("fill", hx, hy, hw * (this.witch.health / this.witch.maxHealth), hh)
	c = {0, 0, 0}
	love.graphics.print("WITCH", hx, hy)
	love.graphics.setColor(255, 255, 255)
	
	love.graphics.setCanvas(screen)
end

function game.kill(this)
	-- write the highscore to a file --
	print(this.score, titlescreen.highscore)
	if this.score > titlescreen.highscore then
		local file = love.filesystem.newFile("score", "w")
		file:write(tostring(this.score))
		file:close()
	end
end