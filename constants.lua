-- Here the game constants are defined.

constants = {}

constants.SCREEN_WIDTH = 320 --800
constants.SCREEN_HEIGHT = 200 --600
constants.BACKGROUND_COLOR = {0.8, 0.8, 1}
constants.PLAYER_MAXSPEED = constants.SCREEN_WIDTH
constants.BALL_MAXSPEED = 0.8 * constants.SCREEN_WIDTH
constants.PLAYER_LENGTH = 24 --60
constants.PLAYER_HEIGHT = 4 --10
constants.BRICK_LENGTH = 16 --40
constants.WALL_THICKNESS = 40 --100
constants.BRICK_COLUMNS = 17
constants.BRICK_ROWS = 7
constants.BRICK_SPACING = 1 --3

-- This is used for diagonal movement calculations.
constants.SQRT2 = math.sqrt(2)

return constants