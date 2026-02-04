constants = require("constants")

-- Some aliases for shorter lines...
local brick_cols = constants.BRICK_COLUMNS
local brick_rows = constants.BRICK_ROWS

-- In this file, we define the entities used in the game.

entities = {
    "player",
    "ball",
    "topwall",
    "bottomwall",
    "leftwall",
    "rightwall",
}

for i=0, brick_cols * brick_rows - 1 do

    table.insert(entities, "brick_" .. i)
    
end

return entities