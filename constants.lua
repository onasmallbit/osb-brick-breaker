-- Here the game constants are defined.

constants = {}

constants.SCREEN_WIDTH = 800
constants.SCREEN_HEIGHT = 600
constants.BACKGROUND_COLOR = {0.8, 0.8, 1}
constants.PLAYER_MAXSPEED = 800
constants.BALL_MAXSPEED = 0.8 * constants.PLAYER_MAXSPEED
constants.PLAYER_LENGTH = 60
constants.PLAYER_HEIGHT = 10
constants.BRICK_LENGTH = 40
constants.WALL_THICKNESS = 100
constants.BRICK_COLUMNS = 17
constants.BRICK_ROWS = 7

-- This is used for diagonal movement calculations.
constants.SQRT2 = math.sqrt(2)

return constants