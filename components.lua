--[[

In this file the base components are defined. They only have data
and in some cases helper functions.

]]--

local components = {}


-- Transform: Gives entities a position vector (pointing to the upper-left corner of the box)
-- and rotation.
components.Transform = {

    position =  {x=0, y=0},
    rotation = 0,
}

-- Rect: Gives the entity a rectangular region related to it. 

components.Rect = {

    w = 0,
    h = 0

}


-- Visual: Gives the entity a visual representation.

components.Visual = {

    color = {r=1, g=1, b=1},
    sprite = nil

}

-- Cinematics: Gives the entity the capability of moving in a cinematic way.

components.Cinematics = {

    velocity = {x=0, y=0},
    acceleration = {x=0, y=0},
    mass = 1

}

return components

