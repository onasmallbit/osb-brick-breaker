-- In this file, we define the entities used in the game.

entities = {
    player = 1,
    ball = 2,
    topwall = 3,
    bottomwall = 4,
    leftwall = 5,
    rightwall = 6,
}

-- Bricks appear from index 7 onwards...

for i=0,118 do
    entities["brick" .. i] = i + 7
end

return entities