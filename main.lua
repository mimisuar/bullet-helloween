function love.load()
	--love._openConsole()
	love.graphics.setDefaultFilter("nearest")
	class = require("middleclass")
	require("titlescreen")
	require("game")
	require("bbox")
	
	require("witch")
	require("witchWeap")
	require("witchWeap.magic")
	require("witchWeap.skele")
	require("witchWeap.corn")
	
	require("enemy")
	
	scrollspeed = 8 * 60
	
	brightness = 1
	love.graphics.setBackgroundColor(27 * brightness, 23 * brightness, 50 * brightness)
	
	trees = love.graphics.newImage("images/trees.png")
	moon = love.graphics.newImage("images/moon.png")
	
	font = love.graphics.newImageFont("images/font.png", "ABCDEFGHIJKLMNOPQRSTUVWXYZ:0123456789 ")
	love.graphics.setFont(font)
	
	local oldPrint = love.graphics.print
	
	function love.graphics.print(...)
		local args = {...}
		args[1] = string.upper(args[1])
		
		if c then
			love.graphics.setColor(c)
			c = nil
		else
			love.graphics.setColor(255, 255, 255)
		end
		oldPrint(unpack(args))
		love.graphics.setColor(255, 255, 255)
	end
	
	treepositions = {}
	local windowWidth = love.window.getDesktopDimensions()
	for i=1, windowWidth / trees:getWidth() do
		table.insert(treepositions, {(i - 1) * trees:getWidth(), love.graphics.getHeight() - trees:getWidth()})
	end
	
	steptimer = 0
	targetdt = 1/60
	
	screen = love.graphics.newCanvas(800, 600)
	titlescreen:load()
	
	song = love.audio.newSource("sounds/helloween - theme.ogg")
	song:setLooping(true)
	song:setVolumeLimits(0, 0.25)
	song:setVolume(0.25)
	song:play()
	
	boomSound = love.audio.newSource("sounds/boom.ogg")
	boomSound:setVolume(0.25)
	
	state = titlescreen
	
	shake = 0
end

function love.update(dt)
	steptimer = steptimer + math.min(0.5, dt)
	dt = targetdt
	
	love.graphics.setBackgroundColor(27 * brightness, 23 * brightness, 50 * brightness)
	
	while steptimer >= targetdt do
		steptimer = steptimer - dt
		
	--	music:update(dt)
		state:update(dt)
		
		-- scroll through the trees --
		local treeSpeed = scrollspeed * dt
		for i=1, #treepositions do
			treepositions[i][1] = math.floor(treepositions[i][1] - treeSpeed)
			
			if treepositions[i][1] < -trees:getWidth() then
				treepositions[i][1] = treepositions[i][1] + screen:getWidth() + trees:getWidth()
			end
		end
		
		if shake > 0 then
			shake = shake - dt
		end
	end
end

function love.keypressed(key, isrepeat)
	if key == "f4" then
		local next = not love.window.getFullscreen()
		
		love.window.setFullscreen(next)
		
		love.mouse.setVisible(not next)
	end
	
	if key == "m" then
		if song:getVolume() == 0.0 then
			song:setVolume(0.5)
		else
			song:setVolume(0.0)
		end
	end
	
	if key == "escape" and state == game then
		--music:fade()
		shake = 0
		state = titlescreen
	end
	
	if key == "0" then
		brightness = math.min(brightness + 1, 3)
	elseif key == "9" then
		brightness = math.max(brightness - 1, 1)
	end
	
	if key == "f5" then
		local s = love.graphics.newScreenshot()
		s:encode("screeny.png")
	end
		
	
	state:keypressed(key, isrepeat)
end

function love.draw()
	
	love.graphics.draw(moon)
	screen:clear()
	love.graphics.setCanvas(screen)
	
	
	
	
	
	state:draw()
	
	for i=1, #treepositions do
		love.graphics.draw(trees, treepositions[i][1], treepositions[i][2])
		
	end
	
	shake = math.min(shake, 1)
		
	local shakeX, shakeY = math.random(-shake, shake) * 10, math.random(-shake, shake) * 10
	
	
	love.graphics.setCanvas()
	
	local targetw, targeth = love.window.getDimensions()
	
	if shake == 0 then
		love.graphics.draw(screen, 0, 0, 0, targetw / screen:getWidth(), targeth / screen:getHeight())
	else
		
		
		love.graphics.draw(screen, shakeX, shakeY, 0, targetw / screen:getWidth(), targeth / screen:getHeight())
		
		
	end
	
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, love.graphics.getHeight() - 10, love.graphics.getWidth(), 10)
	love.graphics.setColor(255, 255, 255)
end

function createState()
	return {
		load = function() end,
		draw = function() end,
		update = function() end,
		keypressed = function() end
	}
end