-- This file is responsible for defining the playing lives system, which is used in the game to track the player's remaining lives.

constants = require "constants"

stats = require "stats"

local stats_system = {}

function stats_system.update()
    if stats["player"].lives <= 0 then
        position["player"].x = (constants.SCREEN_WIDTH / 2)- constants.PLAYER_LENGTH/2
        position["ball"].x = constants.SCREEN_WIDTH/2 - constants.PLAYER_HEIGHT/2
        position["ball"].y = constants.SCREEN_HEIGHT/2 - constants.PLAYER_HEIGHT/2
        velocity["ball"] = {x = 0, y = 0}


        for i=0,118 do
            status["brick_" .. i].dead = false
        end

        stats["player"].points = 0
        stats["player"].lives = 3
    end
end

return stats_system