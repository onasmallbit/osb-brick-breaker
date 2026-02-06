-- main.lua
osbmath = require "osbmath"
constants = require "constants"

entities = require "entities"
position = require "position" 
velocity = require "velocity" 
rect = require "rect" 
status = require "status" 

--TODO: Create helpers.lua and move these functions there...

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

function love.load()
    width = constants.SCREEN_WIDTH
    height = constants.SCREEN_HEIGHT

    player_maxspeed = constants.PLAYER_MAXSPEED
    ball_maxspeed = constants.BALL_MAXSPEED

    player_length = constants.PLAYER_LENGTH
    player_height = constants.PLAYER_HEIGHT

    player_points = 0
    player_lives = 3

    brick_length = constants.BRICK_LENGTH

    sqrt2 = constants.SQRT2

    ball_collided = false


    local font = love.graphics.newFont("ttf/at01.ttf", height * 1/16)
    love.graphics.setFont(font)

    hit_sound = love.audio.newSource("wav/ping_pong_8bit_plop.wav", "static")
    brick_sound = love.audio.newSource("wav/ping_pong_8bit_beeep.wav", "static")
    lose_sound = love.audio.newSource("wav/ping_pong_8bit_peeeeeep.wav", "static")
    
    hit_sound:setVolume(5.0)

    background_music = love.audio.newSource("wav/Mercury.wav", "stream")
    background_music:setLooping(true)
    background_music:setVolume(0.8)
    background_music:play()

    love.window.setTitle("OSB Brick Breaker")
    love.window.setMode(width, height)
    love.graphics.setBackgroundColor(0.8, 0.8, 1)

    velocity["player"].x = player_maxspeed

end

function love.update(dt)

    if love.keyboard.isDown("a") then
        helpers.move("player", -dt)

        if velocity["ball"].y == 0 and velocity["ball"].x == 0 then
            vector_aux = osbmath.new_univector(1,2)
            velocity["ball"] = {x = -ball_maxspeed/sqrt2, y = ball_maxspeed/sqrt2}
        end
    end

    if love.keyboard.isDown("d") then
        helpers.move("player", dt)
        if velocity["ball"].y == 0 and velocity["ball"].x == 0 then
            velocity["ball"] = {x = ball_maxspeed/sqrt2, y = ball_maxspeed/sqrt2}
        end
    end

    if love.keyboard.isDown("r") then
        position["player"].x = (width / 2)-player_length/2
        position["ball"].x = width/2 - player_height/2
        position["ball"].y = height/2 - player_height/2
        velocity["ball"] = {x = 0, y = 0}

        for i=0,118 do
            status["brick_" .. i].dead = false
        end

        player_points = 0
        player_lives = 3
        love.audio.play(lose_sound)
    end

    local collided_this_frame = false

    if helpers.are_colliding("player", "ball") then
        if not ball_collided then
            deltax = (position["ball"].x + rect["ball"].x/2) - position["player"].x

            ball_speed_norm = osbmath.new_univector(-math.cos(math.pi * deltax / rect["player"].x), (-1) * (math.sin(math.pi * deltax / rect["player"].x) * 3/4 + 1/4))
            velocity["ball"].x = ball_maxspeed * ball_speed_norm.x
            velocity["ball"].y = ball_maxspeed * ball_speed_norm.y
        end
        collided_this_frame = true

        love.audio.play(hit_sound)
    end

    if helpers.are_colliding("ball", "topwall") then
        if not ball_collided then
            velocity["ball"].y = math.abs(velocity["ball"].y)
        end
        collided_this_frame = true
        love.audio.play(hit_sound)
    end

    if helpers.are_colliding("ball", "leftwall") then
        if not ball_collided then
            velocity["ball"].x = math.abs(velocity["ball"].x)
        end
        collided_this_frame = true
        love.audio.play(hit_sound)
    end

    if helpers.are_colliding("ball", "rightwall") then
        if not ball_collided then
            velocity["ball"].x = -math.abs(velocity["ball"].x)
        end
        collided_this_frame = true
        love.audio.play(hit_sound)
    end

    if helpers.are_colliding("ball", "bottomwall") then
        velocity["ball"] = {x = 0, y = 0}
        position["ball"].x = width/2 - player_height/2
        position["ball"].y = height/2 - player_height/2
        position["player"].x = (width / 2)-player_length/2
        love.audio.play(lose_sound)
        player_points = player_points - 200
        player_lives = player_lives - 1
    end

    for i=0,118 do
        if not status["brick_" .. i].dead and helpers.are_colliding("ball", "brick_" .. i) then
            if not ball_collided then
                velocity["ball"].y = math.abs(velocity["ball"].y)
            end
            status["brick_" .. i].dead = true
            collided_this_frame = true
            player_points = player_points + 100
            love.audio.play(brick_sound)
        end
    end

    ball_collided = collided_this_frame

    helpers.move("ball", dt)

    if player_lives <= 0 then
        position["player"].x = (width / 2)-player_length/2
        position["ball"].x = width/2 - player_height/2
        position["ball"].y = height/2 - player_height/2
        velocity["ball"] = {x = 0, y = 0}


        for i=0,118 do
            status["brick_" .. i].dead = false
        end

        player_points = 0
        player_lives = 3
    end
end

function love.draw()

    love.graphics.setColor(0.2, 0, 0.8)
    love.graphics.rectangle("fill", position["player"].x, position["player"].y, rect["player"].x, rect["player"].y)

    love.graphics.rectangle("fill", position["ball"].x, position["ball"].y, rect["ball"].x, rect["ball"].y)

    love.graphics.print("POINTS " .. player_points, width*3/4, height * 5/6 )
    love.graphics.print("PRESS R TO RESET", width * 1/40, height * 3/4)
    love.graphics.print("PRESS A, D TO MOVE", width * 1/40, height * 2/3)

    love.graphics.print("LIVES " .. player_lives, width*3/4, height * 3/4)


    love.graphics.setColor(0.8, 0.2, 0)

    for i=0,118 do
        if status["brick_" .. i].dead == false then
            love.graphics.rectangle("fill", position["brick_" .. i].x, position["brick_" .. i].y, rect["brick_" .. i].x, rect["brick_" .. i].y)
        end
    end

end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        print("Click en:", x, y)
    end
end

function love.resize(w, h)
    width, height = w, h
end
