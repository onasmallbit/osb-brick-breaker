-- Here is defined the position component.

entities = require("entities")
constants = require("constants")
osbmath = require("osbmath")

-- Some aliases for shorter lines...

local screen_w = constants.SCREEN_WIDTH
local screen_h = constants.SCREEN_HEIGHT
local player_h = constants.PLAYER_HEIGHT
local player_l = constants.PLAYER_LENGTH
local brick_l = constants.BRICK_LENGTH
local wall_th = constants.WALL_THICKNESS

local brick_cols = constants.BRICK_COLUMNS
local brick_rows = constants.BRICK_ROWS
local brick_sp = constants.BRICK_SPACING

position = {}

-- Initial positions for some entities...

position["player"] = {
    x = (screen_w - player_l) / 2, 
    y = screen_h - player_h * 2
}

position["ball"] = {
    x = (screen_w - player_h) / 2,
    y = (screen_h - player_h) / 2
}

position["topwall"]    = {x = 0                  , y = -wall_th }
position["bottomwall"] = {x = 0                  , y = screen_h }
position["leftwall"]   = {x = -wall_th           , y = 0        }
position["rightwall"]  = {x = screen_w           , y = 0        }

-- Then the bricks...

for i=0,118 do
    local col = i % brick_cols
    local row = i % brick_rows

    position["brick_" .. i] = {
        x = 20 + col*(brick_l + brick_sp) + osbmath.oddevenmap(row)*(brick_l/4 + brick_sp/2),
        y = 20 + row*(brick_l/2 + brick_sp)
    }
    
end

return position