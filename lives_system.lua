-- This file is responsible for defining the playing lives system, which is used in the game to track the player's remaining lives.

local function lives_system()
    if player_lives <= 0 then
        position["player"].x = (width / 2)-player_length/2
        position["ball"].x = width/2 - player_height/2
        position["ball"].y = height/2 - player_height/2
        velocity["ball"] = {x = 0, y = 0}


        for i=0,118 do
            status["brick_" .. i].dead = false
        end

        player_points = 0
        player_lives = 3
    end
end

return lives_system