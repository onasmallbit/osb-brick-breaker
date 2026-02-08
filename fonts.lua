-- This file is responsible for loading and managing the fonts used in the game.

constants = require "constants"

local fonts = {}

function fonts.init()
    local font = love.graphics.newFont("ttf/at01.ttf", constants.SCREEN_HEIGHT * 1/16)
    love.graphics.setFont(font)
end

return fonts