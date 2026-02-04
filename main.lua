-- main.lua
osbmath = require "osbmath"

entities = {}
position = {}
velocity = {}
rect = {}
status = {}

helpers = {}

helpers.move = function(entity_id, dt)
    position[entity_id].x = position[entity_id].x + velocity[entity_id].x * dt
    position[entity_id].y = position[entity_id].y + velocity[entity_id].y * dt

    -- Limitar el movimiento del jugador a la pantalla
    if entity_id == player then
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
    -- Se carga la fuente at01.ttf
    local font = love.graphics.newFont("ttf/at01.ttf", 50)
    love.graphics.setFont(font)

    -- Se cargan los sonidos.
    hit_sound = love.audio.newSource("ogg/ping_pong_8bit_plop.ogg", "static")
    brick_sound = love.audio.newSource("ogg/ping_pong_8bit_beeep.ogg", "static")
    lose_sound = love.audio.newSource("ogg/ping_pong_8bit_peeeeeep.ogg", "static")
    
    hit_sound:setVolume(5.0)

    -- Se carga la música de fondo en bucle
    background_music = love.audio.newSource("wav/Mercury.wav", "stream")
    background_music:setLooping(true)
    background_music:setVolume(0.8)
    background_music:play()


    -- Se ejecuta una sola vez al iniciar el juego
    love.window.setTitle("OSB Brick Breaker")
    love.window.setMode(800, 600)
    love.graphics.setBackgroundColor(0.8, 0.8, 1)

    width, height = love.graphics.getDimensions()

    player_maxspeed = 800
    ball_maxspeed = 0.8 * player_maxspeed

    player_length = 60
    player_height = 10

    player_points = 0
    player_lives = 3

    brick_length = 40

    sqrt2 = math.sqrt(2)

    ball_collided = false

    -- Creamos al jugador.
    entities.player = 1
    player = entities.player
    position[1] = {x = (width - player_length)/2, y = height - player_height*2}
    velocity[1] = {x = player_maxspeed, y = 0}
    rect[1] = {x = player_length, y = player_height}

    -- Creamos la bola. Usamos pos = top-left para que las AABB funcionen correctamente
    entities.ball = 2
    ball = entities.ball
    position[2] = {x = (width - player_height)/2, y = (height - player_height)/2}
    velocity[2] = {x = 0, y = 0}
    rect[2] = {x = player_height, y = player_height}

    -- Creamos las paredes del juego (no visibles).
    entities.topwall = 3
    position[3] = {x = 0, y = -100}
    velocity[3] = {x = 0, y = 0}
    rect[3] = {x = width, y = 100}

    entities.leftwall = 4
    position[4] = {x = -100, y = 0}
    velocity[4] = {x = 0, y = 0}
    rect[4] = {x = 100, y = height}

    entities.rightwall = 5
    position[5] = {x = width, y = 0}
    velocity[5] = {x = 0, y = 0}
    rect[5] = {x = 100, y = height}

    entities.bottomwall = 6
    bottomwall = entities.bottomwall
    position[6] = {x = 0, y = height}
    velocity[6] = {x = 0, y = 0}
    rect[6] = {x = width, y = 100}
    
    -- Creamos los ladrillos (a partir de 7, hasta 126)

    for i=0,6 do
        for j=0,16 do
            local new_id = #position + 1
            entities[new_id] = new_id
            position[new_id] = {x = 20 + j*(brick_length + 3) + osbmath.oddevenmap(i)*(brick_length/4 + 1.5), y = 20 + i*(brick_length/2 + 3)}
            velocity[new_id] = {x = 0, y = 0}
            rect[new_id] = {x = brick_length, y = brick_length/2}
            status[new_id] = {dead = false}
        end
    end

end

function love.update(dt)
    -- Movimiento básico con AD
    if love.keyboard.isDown("a") then
        helpers.move(player, -dt)
        if velocity[ball].y == 0 and velocity[ball].x == 0 then
            vector_aux = osbmath.new_univector(1,2)
            velocity[ball] = {x = -ball_maxspeed/sqrt2, y = ball_maxspeed/sqrt2}
        end
    end

    if love.keyboard.isDown("d") then
        helpers.move(player, dt)
        if velocity[ball].y == 0 and velocity[ball].x == 0 then
            velocity[ball] = {x = ball_maxspeed/sqrt2, y = ball_maxspeed/sqrt2}
        end
    end

    if love.keyboard.isDown("r") then
        position[player].x = (width / 2)-player_length/2
        position[ball].x = width/2 - player_height/2
        position[ball].y = height/2 - player_height/2
        velocity[ball] = {x = 0, y = 0}

        for i=7,#position do
            status[i].dead = false
        end

        player_points = 0
        player_lives = 3
        love.audio.play(lose_sound)
    end

    -- Reescribimos las comprobaciones de colision para ejecutarlas independientemente
    local collided_this_frame = false

    if helpers.are_colliding(entities.player, entities.ball) then
        if not ball_collided then
            deltax = (position[entities.ball].x + rect[entities.ball].x/2) - position[entities.player].x

            ball_speed_norm = osbmath.new_univector(-math.cos(math.pi * deltax / rect[entities.player].x), (-1) * (math.sin(math.pi * deltax / rect[entities.player].x) * 3/4 + 1/4))
            velocity[entities.ball].x = ball_maxspeed * ball_speed_norm.x
            velocity[entities.ball].y = ball_maxspeed * ball_speed_norm.y
        end
        collided_this_frame = true

        -- Toca el sonido de rebote
        love.audio.play(hit_sound)
    end

    if helpers.are_colliding(entities.ball, entities.topwall) then
        if not ball_collided then
            velocity[entities.ball].y = math.abs(velocity[entities.ball].y)
        end
        collided_this_frame = true
        love.audio.play(hit_sound)
    end

    if helpers.are_colliding(entities.ball, entities.leftwall) then
        if not ball_collided then
            velocity[entities.ball].x = math.abs(velocity[entities.ball].x)
        end
        collided_this_frame = true
        love.audio.play(hit_sound)
    end

    if helpers.are_colliding(entities.ball, entities.rightwall) then
        if not ball_collided then
            velocity[entities.ball].x = -math.abs(velocity[entities.ball].x)
        end
        collided_this_frame = true
        love.audio.play(hit_sound)
    end

    if helpers.are_colliding(entities.ball, entities.bottomwall) then
        velocity[entities.ball] = {x = 0, y = 0}
        position[entities.ball].x = width/2 - player_height/2
        position[entities.ball].y = height/2 - player_height/2
        position[player].x = (width / 2)-player_length/2
        love.audio.play(lose_sound)
        player_points = player_points - 200
        player_lives = player_lives - 1
    end

    for i=7,#position do
        if not status[i].dead and helpers.are_colliding(entities.ball, entities[i]) then
            if not ball_collided then
                velocity[entities.ball].y = math.abs(velocity[entities.ball].y)
            end
            status[i].dead = true
            collided_this_frame = true
            player_points = player_points + 100
            love.audio.play(brick_sound)
        end
    end

    ball_collided = collided_this_frame
    -- Movimiento de la bola
    helpers.move(entities.ball, dt)

    if player_lives <= 0 then
        position[entities.player].x = (width / 2)-player_length/2
        position[entities.ball].x = width/2 - player_height/2
        position[entities.ball].y = height/2 - player_height/2
        velocity[entities.ball] = {x = 0, y = 0}


        for i=7,#position do
            status[i].dead = false
        end

        player_points = 0
        player_lives = 3
    end
end

function love.draw()
    -- Dibujado
    love.graphics.setColor(0.2, 0, 0.8)
    love.graphics.rectangle("fill", position[player].x, position[player].y, rect[player].x, rect[player].y)

    love.graphics.rectangle("fill", position[entities.ball].x, position[entities.ball].y, rect[entities.ball].x, rect[entities.ball].y)

    love.graphics.print("POINTS " .. player_points, width*3/4, height - 100)
    love.graphics.print("PRESS R TO RESET", 20, height - 150)
    love.graphics.print("PRESS A, D TO MOVE", 20, height - 200)

    love.graphics.print("LIVES " .. player_lives, width*3/4, height - 150)


    love.graphics.setColor(0.8, 0.2, 0)

    for i=7,#position do
        if status[i].dead == false then
            love.graphics.rectangle("fill", position[i].x, position[i].y, rect[i].x, rect[i].y)
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
