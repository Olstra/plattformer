--[[
    Plattformer

    -- Constants list --

    Author: olstra
    Date: Jan 2020
    as a part of 'edx course CS50g'
]]

-- size of the actual window
WIN_W = 1280
WIN_H = 720

-- size we're trying to emulate with push
VIRTUAL_W = 256
VIRTUAL_H = 144


-- TILES
TILE_SIZE = 16
-- number of tiles in each tile set
TILE_SET_W = 5
TILE_SET_H = 4

-- number of tile sets in sheet
TILE_SETS_WIDE = 6
TILE_SETS_TALL = 10

-- number of topper sets in sheet
TOPPER_SETS_WIDE = 6
TOPPER_SETS_TALL = 18

-- TILE IDs
ID_GROUND = 3
ID_SKY = 5
ID_LAVA = 0
ID_EXIT = 30

SOLID = {ID_GROUND, ID_LAVA}

--MAP_H = VIRTUAL_H / TILE_SIZE
--MAP_W = 100

--FLOOR_H = MAP_H * 2/3

-- cookie
COOKIE_W = 10

-- sign (exit)
SIGN_W = 16
SIGN_H = 16

-- character
CHARA_W = 16
CHARA_H = 20

GRAVITY = 10
-----------------------------