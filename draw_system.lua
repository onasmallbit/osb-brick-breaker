-- This file defines the draw system, which is responsible for rendering the game objects on the screen.

local constants = require "constants"

local pos = require "position"
local r = require "rect"
local s = require "stats"


local function draw_system()

    love.graphics.setColor(constants.MAIN_COLOR)
    love.graphics.rectangle("fill", pos["player"].x, pos["player"].y, r["player"].x, r["player"].y)

    love.graphics.rectangle("fill", pos["ball"].x, pos["ball"].y, r["ball"].x, r["ball"].y)

    love.graphics.print("POINTS " .. s["player"].points, constants.SCREEN_WIDTH * 3/4, constants.SCREEN_HEIGHT * 5/6 )
    love.graphics.print("PRESS R TO RESET", constants.SCREEN_WIDTH * 1/40, constants.SCREEN_HEIGHT * 3/4)
    love.graphics.print("PRESS A, D TO MOVE", constants.SCREEN_WIDTH * 1/40, constants.SCREEN_HEIGHT * 2/3)

    love.graphics.print("LIVES " .. s["player"].lives, constants.SCREEN_WIDTH*3/4, constants.SCREEN_HEIGHT * 3/4)

    love.graphics.setColor(constants.BRICK_COLOR)

    for i=0,118 do
        if status["brick_" .. i].dead == false then
            love.graphics.rectangle("fill", pos["brick_" .. i].x, pos["brick_" .. i].y, r["brick_" .. i].x, r["brick_" .. i].y)
        end
    end

end

return draw_system
