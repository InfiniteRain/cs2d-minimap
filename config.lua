-----------------------------------
-- Config for the minimap script --
-----------------------------------
--------------------------------------------
-- 'align' Parameter can be one of those: --
-- 0 - Center							  --
-- 1 - Left up corner					  --
-- 2 - Left down corner					  --
-- 3 - Right up corner					  --
-- 4 - Right down corner				  --
--------------------------------------------

cr.minimap.config = {
	position = {640, 39, 2}; -- {x, y, alight} - Position of the map on the player's screen
	
	hideKillMessages = true; -- Hides kill messages, and replaces it with the custom scripted one
	customKillMessagesPosition = {640, map('ysize')*2+39}; -- Position of the custom scripted kill messages (works only if 'hideKillMessages' is set to true)
	
	mapIconImage = "gfx/2x2.bmp"; -- Image of the players which will be displayed on the minimap
}