constants = require("constants")

-- In this file, we define the entities used in the game.

entities = {
    player = 1,
    ball = 2,
    topwall = 3,
    bottomwall = 4,
    leftwall = 5,
    rightwall = 6,
}

first_brick_id = #entities + 1

for i=0,constants.BRICK_COLUMNS * constants.BRICK_ROWS - 1 do
    entities["brick" .. i] = i + 
end

return entities