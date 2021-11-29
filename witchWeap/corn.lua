witchWeap.corn = class("witchWeap.corn", witchWeap)
witchWeap.corn.img = love.graphics.newImage("images/witchCorn.png")
witchWeap.sound = love.audio.newSource("sounds/witchmagic.ogg")

function witchWeap.corn.init(this)
	this.firerate = 0.5
	this.projs = {}
	this.projspeed = 4 * 60
	this.frame = 1
	this.frametime = 0
	this.updatetime = 0.2
	this.ammo = 10
end

function witchWeap.corn.update(this, dt)
	for i=#this.projs, 1, -1 do
		local p = this.projs[i]
		if p then
			p[1] = p[1] + this.projspeed * dt
			p[2] = p[2] + p.yspeed * dt
			p.yspeed = p.yspeed + 24
			p.box:move(p[1], p[2])
			
			p[3] = p[3] + dt
			
			if p[1] > screen:getWidth() or p.destroy then
				table.remove(this.projs, i)
			end
		end
	end
end

function witchWeap.corn.fire(this, dt)
	local p  = {game.witch.x + 60, game.witch.y + 10, 0}
	p.box = bbox(p[1], p[2], 40, 40)
	table.insert(this.projs, 1, p)
	
	p.yspeed = -8 * 60
	
	this.sound:stop()
	this.sound:play()
	
	p.name = this.class.name
	
	this.ammo = this.ammo - 1
	
	return this.firerate
end

function witchWeap.corn.draw(this, dt)
	for i=1, #this.projs do
		local p = this.projs[i]
		if p then
			local x, y, r = unpack(p)
			love.graphics.draw(this.img, x, y, math.deg(r), nil, nil, 10, 10)
		end
	end
end