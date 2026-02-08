-- This file is responsible for loading and managing the fonts used in the game.

local fonts = {}

function fonts.init()
    local font = love.graphics.newFont("ttf/at01.ttf", height * 1/16)
    love.graphics.setFont(font)
end

return fonts