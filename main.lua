-- main.lua
osbmath = require "osbmath"
constants = require "constants"
sounds = require "sounds"
osbwindow = require "osbwindow"
fonts = require "fonts"
helpers = require "helpers"
keyboard = require "keyboard"

collition_system = require "collition_system"
draw_system = require "draw_system"
stats_system = require "stats_system"

entities = require "entities"
position = require "position" 
velocity = require "velocity" 
rect = require "rect"
stats = require "stats" 
status = require "status" 

function love.load()

	
    sounds.background_music:play()
    osbwindow.init()
    fonts.init()

end

function love.update(dt)

    keyboard.update(dt)
    collition_system:update()
    helpers.move("ball", dt)
    stats_system.update()

end

function love.draw()
    draw_system()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

