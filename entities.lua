-- Aca estan las entidades del juego.
entities = {}

function entities.create(pos_vector, speed_vector, dims_vector)
    local entity = {
        pos = pos_vector,
        speed = speed_vector,
        dims = dims_vector
    }
    return entity
end

function entities.move(entity, dt)
    entity.pos.x = entity.pos.x + entity.speed.x * dt
    entity.pos.y = entity.pos.y + entity.speed.y * dt
end

function entities.are_colliding(entity1, entity2)
    local x1, y1 = entity1.pos.x, entity1.pos.y
    local w1, h1 = entity1.dims.x, entity1.dims.y
    local x2, y2 = entity2.pos.x, entity2.pos.y
    local w2, h2 = entity2.dims.x, entity2.dims.y

    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end

entities.list = {}

return entities