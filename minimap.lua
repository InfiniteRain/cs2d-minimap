if not cr then cr = {} end

cr.minimap = {
	player = {};
	killMessages = {'', '', '', '', ''};
	
	hooks = {
		startround = function(mode)
			cr.minimap.image = image('maps/'.. map('name') ..'.png', cr.minimap.globalPosition[1], cr.minimap.globalPosition[2], 2)
			for _, id in pairs(player(0, 'table')) do
				cr.minimap.player[id].mapIconImage = image(cr.minimap.config.mapIconImage, 0, 0, 2); 
				imagealpha(cr.minimap.player[id].mapIconImage, 1)
				imagecolor(cr.minimap.player[id].mapIconImage, player(id, 'team') == 1 and 255 or 0, 0, player(id, 'team') == 2 and 255 or 0)
			end
			cr.minimap.funcs.updateMinimap()
		end;
		
		spawn = function(id)
			imagealpha(cr.minimap.player[id].mapIconImage, 1)
		end;
		
		join = function(id)
			cr.minimap.player[id] = {justJoined = true}
		end;
		
		team = function(id, team)
			if not player(id, 'bot') then
				if cr.minimap.player[id].justJoined then
					cr.minimap.player[id] = {
						justJoined = false;
						mapIconImage = image(cr.minimap.config.mapIconImage, 0, 0, 2); 
					};
				end
			else
				cr.minimap.player[id] = {
					justJoined = false;
					mapIconImage = image(cr.minimap.config.mapIconImage, 0, 0, 2); 
				}
			end
			imagealpha(cr.minimap.player[id].mapIconImage, 0)
			imagecolor(cr.minimap.player[id].mapIconImage, team == 1 and 255 or 0, 0, team == 2 and 255 or 0)
		end;
		
		movetile = function(id, x, y)
			cr.minimap.funcs.updateMinimap()
		end;
		
		die = function(victim, killer, weapon, x, y)
			imagealpha(cr.minimap.player[victim].mapIconImage, 0)
			if cr.minimap.config.hideKillMessages then
				local vt, kt = player(victim, 'team'), player(killer, 'team')
				if killer == 0 or weapon == 0 then
					cr.minimap.funcs.updateKillMessages(string.char(169) .. (vt == 1 and '255025000' or '050150255') .. player(victim, 'name') ..' '.. string.char(169) ..'255220000died')
				else
					cr.minimap.funcs.updateKillMessages(string.char(169) .. (vt == 1 and '255025000' or '050150255') .. player(killer, 'name') ..' '.. string.char(169) ..'255220000'.. itemtype(weapon, 'name') ..' '.. string.char(169) .. (kt == 1 and '255025000' or '050150255') .. player(victim, 'name'))
				end
			end
		end;
		
		leave = function(id)
			freeimage(cr.minimap.player[id].mapIconImage)
		end;
	};
	
	funcs = {
		updateMinimap = function()
			for _, id in pairs(player(0, 'tableliving')) do
				imagepos(cr.minimap.player[id].mapIconImage, cr.minimap.globalPosition[1] - map('xsize') + player(id, 'tilex')*2, cr.minimap.globalPosition[2] - map('ysize') + player(id, 'tiley')*2, 0)
			end
		end;
		
		updateKillMessages = function(text)
			for i = 5, 2, -1 do
				cr.minimap.killMessages[i] = cr.minimap.killMessages[i-1] 
				parse('hudtxt '.. i ..' "'.. cr.minimap.killMessages[i] ..'" '.. cr.minimap.config.customKillMessagesPosition[1] ..' '.. cr.minimap.config.customKillMessagesPosition[2] + i*17-17 ..' 2')
			end
			cr.minimap.killMessages[1] = text
			parse('hudtxt '.. 1 ..' "'.. cr.minimap.killMessages[1] ..'" '.. cr.minimap.config.customKillMessagesPosition[1] ..' '.. cr.minimap.config.customKillMessagesPosition[2] ..' 2')
		end;
	};
}

-- Adding hooks --
addhook('startround', 'cr.minimap.hooks.startround')
addhook('spawn', 'cr.minimap.hooks.spawn')
addhook('join', 'cr.minimap.hooks.join')
addhook('team', 'cr.minimap.hooks.team')
addhook('movetile', 'cr.minimap.hooks.movetile')
addhook('die', 'cr.minimap.hooks.die')
addhook('leave', 'cr.minimap.hooks.leave')
------------------

-- Loading config file --
dofile('sys/lua/config.lua')

local confpos, pos = cr.minimap.config.position, {}
if confpos[3] == 0 then
	pos = {confpos[1], confpos[2]}
elseif confpos[3] == 1 then
	pos = {confpos[1] - map('xsize'), confpos[2] - map('ysize')}
elseif confpos[3] == 2 then
	pos = {confpos[1] - map('xsize'), confpos[2] + map('ysize')}
elseif confpos[3] == 3 then
	pos = {confpos[1] + map('xsize'), confpos[2] - map('ysize')}
elseif  confpos[3] == 4 then
	pos = {confpos[1] + map('ysize'), confpos[2] + map('xsize')}
end
cr.minimap.globalPosition = pos

if cr.minimap.config.hideKillMessages then
	parse('mp_hud 63')
end

cr.minimap.image = image('maps/'.. map('name') ..'.png', cr.minimap.globalPosition[1], cr.minimap.globalPosition[2], 2)
-------------------------