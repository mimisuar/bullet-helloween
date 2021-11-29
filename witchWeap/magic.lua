witchWeap.magic = class("witchWeap.magic", witchWeap)
witchWeap.magic.img = love.graphics.newImage("images/witchMagic.png")
witchWeap.magic.quads = {}
for i=1, 3 do
	i = i - 1
	table.insert(witchWeap.magic.quads, love.graphics.newQuad(i * 40, 0, 40, 40, 3 * 40, 40))
end
witchWeap.sound = love.audio.newSource("sounds/witchmagic.ogg")

function witchWeap.magic.init(this)
	this.firerate = 0.1
	this.projs = {}
	this.projspeed = 30 * 60
	this.frame = 1
	this.frametime = 0
	this.updatetime = 0.2
end

function witchWeap.magic.update(this, dt)
	
	this.frametime = this.frametime + dt
	if this.frametime > this.updatetime then
		this.frametime = 0
		this.frame = this.frame + 1
		if this.frame > #this.quads then
			this.frame = 1
		end
	end
	
	for i=#this.projs, 1, -1 do
		local p = this.projs[i]
		if p then
			p[1] = p[1] + this.projspeed * dt
			p.box:move(p[1], p[2])
			
			if p[1] > screen:getWidth() or p.destroy then
				table.remove(this.projs, i)
			end
		end
	end
end

function witchWeap.magic.fire(this, dt)
	local p  = {game.witch.x + 60, game.witch.y + 10}
	p.box = bbox(p[1], p[2], 40, 40)
	table.insert(this.projs, 1, p)
	
	this.sound:stop()
	this.sound:play()
	
	p.name = this.class.name
	
	return this.firerate
end

function witchWeap.magic.draw(this, dt)
	for i=1, #this.projs do
		local p = this.projs[i]
		if p then
			love.graphics.draw(this.img, this.quads[this.frame], unpack(p))
		end
	end
end