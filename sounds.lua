-- In this file, sounds are loaded.

local sounds = {}

sounds.hit_sound = love.audio.newSource("wav/ping_pong_8bit_plop.wav", "static")
sounds.hit_sound:setVolume(5.0)

sounds.brick_sound = love.audio.newSource("wav/ping_pong_8bit_beeep.wav", "static")
sounds.lose_sound = love.audio.newSource("wav/ping_pong_8bit_peeeeeep.wav", "static")    

sounds.background_music = love.audio.newSource("wav/Mercury.wav", "stream")

sounds.background_music:setLooping(true)
sounds.background_music:setVolume(0.8)

-- Activate the background music immediately so that it starts playing as soon as the game is launched.

function sounds.init()
    sounds.background_music:play()
end

return sounds