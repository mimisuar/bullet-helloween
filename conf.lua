function love.conf(t)
	t.identity = "bullethelloween"
	t.version = "0.9.2"
	t.console = false
	
	t.window.title = "Bullet-Helloween"
	t.window.icon = "images/icon.png"
	t.window.vsync = false
	t.window.fullscreentype = "desktop"
	
	t.modules.joystick = false
	t.modules.physics = false
end