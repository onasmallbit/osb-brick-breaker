-- This file is responsible for loading and managing the keyboard input.
-- It is accesed every update cycle.

local keyboard = {}

local ball_maxspeed = constants.BALL_MAXSPEED
local player_maxspeed = constants.PLAYER_MAXSPEED
local player_length = constants.PLAYER_LENGTH
local player_height = constants.PLAYER_HEIGHT
local width = constants.SCREEN_WIDTH
local height = constants.SCREEN_HEIGHT
local sqrt2 = constants.SQRT2

function keyboard.update(dt)

    if love.keyboard.isDown("a") then
        helpers.move("player", -dt)

        if velocity["ball"].y == 0 and velocity["ball"].x == 0 then
            vector_aux = osbmath.new_univector(1,2)
            velocity["ball"] = {x = -ball_maxspeed/sqrt2, y = ball_maxspeed/sqrt2}
        end
    end

    if love.keyboard.isDown("d") then
        helpers.move("player", dt)
        if velocity["ball"].y == 0 and velocity["ball"].x == 0 then
            velocity["ball"] = {x = ball_maxspeed/sqrt2, y = ball_maxspeed/sqrt2}
        end
    end

    if love.keyboard.isDown("r") then
        position["player"].x = (width / 2)-player_length/2
        position["ball"].x = width/2 - player_height/2
        position["ball"].y = height/2 - player_height/2
        velocity["ball"] = {x = 0, y = 0}

        for i=0,118 do
            status["brick_" .. i].dead = false
        end

        player_points = 0
        player_lives = 3
        love.audio.play(sounds.lose_sound)
    end

end

return keyboard