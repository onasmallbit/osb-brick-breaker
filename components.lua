--[[

Este es el archivo donde se definen los componentes del juego. Cada componente
es una tabla que contiene funciones que definen su comportamiento.
Cada entidad puede estar suscripta a uno o más componentes, y en cada frame
se ejecutan las funciones de los componentes a los que está suscripta.

]]--

local osbmath = require "osbmath"

local components = {}


-- Función para agregar un componente a una entidad.
function components.AddComponent(entity, name, component)
    
    local copy = {}

    for k, v in pairs(component) do
        copy[k] = v
    end

    entity[name] = copy
end

-- Función para crear una copia de un componente.
function components.CopyComponent(component)
    
    local copy = {}

    for k, v in pairs(component) do
        copy[k] = v
    end

    return copy

end

-- Función para combinar dos componentes en uno (si hay conflictos entre miembros iguales, prevalecen los
-- del componente 2).
function components.CombineComponents(comp1, comp2)
    
    local combination = {}

    for k, v in pairs(comp1) do
        combination[k] = v
    end

    for k, v in pairs(comp2) do
        combination[k] = v
    end

    return combination

end

-------- Transform Component --------

-- "Transform" Define la posición y rotación de una entidad en el espacio del juego.
-- Provee funciones para mover y rotar la entidad, así como para obtener su posición actual.

components.Transform = {}

components.Transform = {

    x = 0,
    y = 0,
    rotation = 0,

    move = function(self, dx, dy)
        self.x = self.x + dx
        self.y = self.y + dy
    end,

    rotate = function(self, dtheta)
        self.rotation = self.rotation + dtheta
    end,

    getPosition = function(self)
        return self.x, self.y
    end

}


-------- GraphicRect Component --------

-- "GraphicRect" Define una región rectangular en la pantalla propia de la entidad. Se puede
-- rellenar de un color solido, dibujar su contorno, o dibujar una imagen en su interior.
-- Nota: No tiene nada que ver con la física o las colisiones, es solo para dibujar.
-- Nota2: Requiere el componente Transform para posicionarse correctamente en pantalla.

components.GraphicRect = {}

components.GraphicRect = {

    w = 0,
    h = 0,
    color = {0.8, 0, 0.2},

    draw = function(self) 
        love.graphics.setColor(self.color)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    end

}


--------- CollRect Component ---------

-- "CollRect" Define una región rectangular para colisiones AABB (Axis-Aligned Bounding Box).
-- Provee funciones para detectar colisiones con otras entidades que también tengan este componente.
-- Nota: Requiere el componente Transform para posicionarse correctamente en el espacio del juego.

components.CollRect = {

    w = 0,
    h = 0,

    isCollidingWith = function(self, other)
        return not (self.x + self.w < other.x or
                    self.x > other.x + other.w or
                    self.y + self.h < other.y or
                    self.y > other.y + other.h)
    end

}

--------- InvisibleBody Component ---------

-- InvisibleBody es la combinacion de un CollRect y un Transform, que permite a una entidad
-- tener posicion y colision. Evita tener que agregar los tres componentes por separado.

components.InvisibleBody = components.CombineComponents(
    components.Transform,
    components.CollRect
)

--------- Body Component ---------

-- Body es la combinacion de un CollRect, un GraphicRect y un Transform, que permite a una entidad
-- tener tanto colisiones como dibujo en pantalla. Evita tener que agregar los tres componentes por separado.

components.Body = components.CombineComponents(
    components.Transform,
    components.CombineComponents(
        components.CollRect,
        components.GraphicRect
    )
)

--------- CinematicBody Component ---------

-- CinematicBody es un Body con capacidad de movimiento.

components.CinematicBody = components.CopyComponent(components.Body)

components.CinematicBody.vx = 0
components.CinematicBody.vy = 0

-- Nota: vel_vector es un vector con campos x e y.
components.CinematicBody.setVelocity = function(self, vel_vector)
    self.vx = vel_vector.x
    self.vy = vel_vector.y
end

components.CinematicBody.updatePosition = function(self, dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

return components