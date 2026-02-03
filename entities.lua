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

for i=7,125 do
    entities["brick_" .. i] = i
end