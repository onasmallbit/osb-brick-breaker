-- Here is defined the status component.

status = {}

-- Initial positions for some entities...

for i=0,118 do

    local col = i % brick_cols
    local row = i % brick_rows

    status["brick" .. i] = {dead = false}
    
end

return status