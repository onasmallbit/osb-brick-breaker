-- Aca pongo las funciones y tipos matemticos que use en el juego.

osbmath = {}

function osbmath.new_univector(x,y)
    magnitude = math.sqrt(x*x + y*y)
    
    if magnitude == 0 then
        return {x = 0, y = 0}
    end 

    return {x = x/magnitude, y = y/magnitude}
end

function osbmath.scale_univector(univector, scale)
    return {x = univector.x * scale, y = univector.y * scale}
end

function osbmath.new_vector_rectangular(x,y)
    return {x = x, y = y}
end

function osbmath.new_vector_polar(magnitude, angle)
    return {x = magnitude * math.cos(angle), y = magnitude * math.sin(angle)}
end

-- Si el numero es impar, devuelve -1. Si es par, devuelve 1.
function osbmath.oddevenmap(number)
    if number % 2 == 0 then
        return 1
    else
        return -1
    end
end

return osbmath