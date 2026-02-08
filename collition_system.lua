-- This file is responsible for loading and managing the physical collision of the game.
-- It is accessed every update cycle.

constants = require "constants"
helpers = require "helpers"

position = require "position"
rect = require "rect"
velocity = require "velocity"

local player_maxspeed = constants.PLAYER_MAXSPEED
local player_w = constants.PLAYER_LENGTH
local player_h = constants.PLAYER_HEIGHT

local ball_maxspeed = constants.BALL_MAXSPEED

local screen_w = constants.SCREEN_WIDTH
local screen_h = constants.SCREEN_HEIGHT

local collition_system = {}

collition_system.ball_collided = false
collition_system.collided_this_frame = false

function collition_system.update(self)

    if helpers.are_colliding("player", "ball") then
        if not self.ball_collided then
            deltax = (position["ball"].x + rect["ball"].x/2) - position["player"].x

            ball_speed_norm = osbmath.new_univector(-math.cos(math.pi * deltax / rect["player"].x), (-1) * (math.sin(math.pi * deltax / rect["player"].x) * 3/4 + 1/4))
            velocity["ball"].x = ball_maxspeed * ball_speed_norm.x
            velocity["ball"].y = ball_maxspeed * ball_speed_norm.y
        end
        self.collided_this_frame = true

        love.audio.play(sounds.hit_sound)
    end

    if helpers.are_colliding("ball", "topwall") then
        if not self.ball_collided then
            velocity["ball"].y = math.abs(velocity["ball"].y)
        end
        collided_this_frame = true
        love.audio.play(sounds.hit_sound)
    end

    if helpers.are_colliding("ball", "leftwall") then
        if not self.ball_collided then
            velocity["ball"].x = math.abs(velocity["ball"].x)
        end
        self.collided_this_frame = true
        love.audio.play(sounds.hit_sound)
    end

    if helpers.are_colliding("ball", "rightwall") then
        if not self.ball_collided then
            velocity["ball"].x = -math.abs(velocity["ball"].x)
        end
        self.collided_this_frame = true
        love.audio.play(sounds.hit_sound)
    end

    if helpers.are_colliding("ball", "bottomwall") then
        velocity["ball"] = {x = 0, y = 0}
        position["ball"].x = screen_w/2 - player_h/2
        position["ball"].y = screen_h/2 - player_h/2
        position["player"].x = (screen_w / 2) - player_w/2
        love.audio.play(sounds.lose_sound)
        stats["player"].points = stats["player"].points - 200
        stats["player"].lives = stats["player"].lives - 1
    end

    for i=0,118 do
        if not status["brick_" .. i].dead and helpers.are_colliding("ball", "brick_" .. i) then
            if not self.ball_collided then
                velocity["ball"].y = math.abs(velocity["ball"].y)
            end
            status["brick_" .. i].dead = true
            self.collided_this_frame = true
            stats["player"].points = stats["player"].points + 100
            love.audio.play(sounds.brick_sound)
        end
    end

    ball_collided = collided_this_frame

end


return collition_system
