titlescreen = createState()

function titlescreen.load(this)
	this.logo = love.graphics.newImage("images/logo.png")
--	this.font = love.graphics.newFont("images/osn.ttf", 60)
	
	if love.filesystem.exists("score") then
		local hs = love.filesystem.read("score")
		print(hs)
		this.highscore = tonumber(hs) or 0
	else
		this.highscore = 0
	end
end

function titlescreen.draw(this)
	love.graphics.draw(this.logo, 10, 10)
	
--	love.graphics.setFont(this.font)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(string.format("High-Score: %06d", this.highscore), 70, this.logo:getHeight() - 60)
	love.graphics.print("Press Space to Begin", 70, this.logo:getHeight())
	love.graphics.setColor(255, 255, 255)
end

function titlescreen.keypressed(this, key, isrepeat)
	if key == " " then
		-- go to the game --
		game:load()
		
		state = game
	elseif key == "f" then
		game:load()
		
		game.furymode = true
		
		state = game
	end
end