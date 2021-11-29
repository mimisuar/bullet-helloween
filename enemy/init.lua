enemy = class("enemy")
enemy.painSound = love.audio.newSource("sounds/monsterpain.ogg")
enemy.painSound:setVolume(0.25)
enemy.types = {}

require("enemy.pumpkin")
require("enemy.skele")
require("enemy.corn")
require("enemy.cornWeap")
require("enemy.weapOrb")