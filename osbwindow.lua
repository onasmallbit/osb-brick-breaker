-- This file is responsible for setting up the game window and its properties.

constants = require("constants")
 
local osbwindow = {}

function osbwindow.init()
    love.window.setTitle(constants.WINDOW_TITLE)
    love.window.setMode(constants.SCREEN_WIDTH, constants.SCREEN_HEIGHT)
    love.graphics.setBackgroundColor(constants.BACKGROUND_COLOR)
end

return osbwindow