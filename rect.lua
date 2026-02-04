-- Here is defined the rect component.

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

rect = {}

-- Initial positions for some entities...

rect["player"] = {x = player_l, y = player_h}

rect["ball"] = {x = player_h, y = player_h}

rect["topwall"]    = {x = screen_w, y = wall_th }
rect["bottomwall"] = rect["topwall"]

rect["leftwall"]   = {x = wall_th, y = screen_h}
rect["rightwall"]  = rect["leftwall"]

-- Then the bricks...

for i=0,118 do

    local col = i % brick_cols
    local row = i % brick_rows

    rect["brick_" .. i] = {
        x = brick_l,
        y = brick_l/2
    }
    
end

return rect