-- Here is defined the velocity component.

constants = require "constants"

velocity = {}

-- Initial positions for some entities...

velocity["player"] = {x = constants.PLAYER_MAXSPEED, y = 0}

velocity["ball"] = {x = 0, y = 0}

return velocity
