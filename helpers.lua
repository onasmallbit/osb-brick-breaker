-- This file is responsible for defining helper functions used throughout the game.

helpers = {}
 
helpers.move = function(entity_id, dt)
    position[entity_id].x = position[entity_id].x + velocity[entity_id].x * dt
    position[entity_id].y = position[entity_id].y + velocity[entity_id].y * dt

    if entity_id == "player" then
        if position[entity_id].x < 0 then
            position[entity_id].x = 0
        end
        if position[entity_id].x + rect[entity_id].x > width then
            position[entity_id].x = width - rect[entity_id].x
        end
    end
end

helpers.are_colliding = function(entity1_id, entity2_id)
    local pos1 = position[entity1_id]
    local pos2 = position[entity2_id]
    local dim1 = rect[entity1_id]
    local dim2 = rect[entity2_id]

    return pos1.x < pos2.x + dim2.x and
           pos1.x + dim1.x > pos2.x and
           pos1.y < pos2.y + dim2.y and
           pos1.y + dim1.y > pos2.y
end

return helpers