-- main.lua
osbmath = require "osbmath"
constants = require "constants"
sounds = require "sounds"
osbwindow = require "osbwindow"
fonts = require "fonts"
helpers = require "helpers"
keyboard = require "keyboard"

collition_system = require "collition_system"
lives_system = require "lives_system"

entities = require "entities"
position = require "position" 
velocity = require "velocity" 
rect = require "rect" 
status = require "status" 

function love.load()
    width = constants.SCREEN_WIDTH
    height = constants.SCREEN_HEIGHT

    player_maxspeed = constants.PLAYER_MAXSPEED
    ball_maxspeed = constants.BALL_MAXSPEED

    player_length = constants.PLAYER_LENGTH
    player_height = constants.PLAYER_HEIGHT

    player_points = 0
    player_lives = 3

    brick_length = constants.BRICK_LENGTH

    sqrt2 = constants.SQRT2

    ball_collided = false

    osbwindow.init()
    sounds.init()
    fonts.init()

    velocity["player"].x = player_maxspeed

end

function love.update(dt)

    keyboard.update(dt)
    collition_system()
    helpers.move("ball", dt)
    lives_system()

end

function love.draw()

    love.graphics.setColor(0.2, 0, 0.8)
    love.graphics.rectangle("fill", position["player"].x, position["player"].y, rect["player"].x, rect["player"].y)

    love.graphics.rectangle("fill", position["ball"].x, position["ball"].y, rect["ball"].x, rect["ball"].y)

    love.graphics.print("POINTS " .. player_points, width*3/4, height * 5/6 )
    love.graphics.print("PRESS R TO RESET", width * 1/40, height * 3/4)
    love.graphics.print("PRESS A, D TO MOVE", width * 1/40, height * 2/3)

    love.graphics.print("LIVES " .. player_lives, width*3/4, height * 3/4)


    love.graphics.setColor(0.8, 0.2, 0)

    for i=0,118 do
        if status["brick_" .. i].dead == false then
            love.graphics.rectangle("fill", position["brick_" .. i].x, position["brick_" .. i].y, rect["brick_" .. i].x, rect["brick_" .. i].y)
        end
    end

end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

