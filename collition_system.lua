-- This file is responsible for loading and managing the physical collision of the game.
-- It is accessed every update cycle.

local function collition_system()

    local collided_this_frame = false

    if helpers.are_colliding("player", "ball") then
        if not ball_collided then
            deltax = (position["ball"].x + rect["ball"].x/2) - position["player"].x

            ball_speed_norm = osbmath.new_univector(-math.cos(math.pi * deltax / rect["player"].x), (-1) * (math.sin(math.pi * deltax / rect["player"].x) * 3/4 + 1/4))
            velocity["ball"].x = ball_maxspeed * ball_speed_norm.x
            velocity["ball"].y = ball_maxspeed * ball_speed_norm.y
        end
        collided_this_frame = true

        love.audio.play(sounds.hit_sound)
    end

    if helpers.are_colliding("ball", "topwall") then
        if not ball_collided then
            velocity["ball"].y = math.abs(velocity["ball"].y)
        end
        collided_this_frame = true
        love.audio.play(sounds.hit_sound)
    end

    if helpers.are_colliding("ball", "leftwall") then
        if not ball_collided then
            velocity["ball"].x = math.abs(velocity["ball"].x)
        end
        collided_this_frame = true
        love.audio.play(sounds.hit_sound)
    end

    if helpers.are_colliding("ball", "rightwall") then
        if not ball_collided then
            velocity["ball"].x = -math.abs(velocity["ball"].x)
        end
        collided_this_frame = true
        love.audio.play(sounds.hit_sound)
    end

    if helpers.are_colliding("ball", "bottomwall") then
        velocity["ball"] = {x = 0, y = 0}
        position["ball"].x = width/2 - player_height/2
        position["ball"].y = height/2 - player_height/2
        position["player"].x = (width / 2)-player_length/2
        love.audio.play(sounds.lose_sound)
        player_points = player_points - 200
        player_lives = player_lives - 1
    end

    for i=0,118 do
        if not status["brick_" .. i].dead and helpers.are_colliding("ball", "brick_" .. i) then
            if not ball_collided then
                velocity["ball"].y = math.abs(velocity["ball"].y)
            end
            status["brick_" .. i].dead = true
            collided_this_frame = true
            player_points = player_points + 100
            love.audio.play(sounds.brick_sound)
        end
    end

    ball_collided = collided_this_frame

end

return collition_system