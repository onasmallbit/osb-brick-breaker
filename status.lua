constants = require "constants"

local brick_cols = constants.BRICK_COLUMNS
local brick_rows = constants.BRICK_ROWS

-- Here is defined the status component.

status = {}

-- Initial positions for some entities...

for i=0,118 do

    local col = i % brick_cols
    local row = i % brick_rows

    status["brick_" .. i] = {dead = false}
    
end

return status