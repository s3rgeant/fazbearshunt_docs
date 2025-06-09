hook.Add("PostGamemodeLoaded", "fh_test_tjoc", function()
	if engine.ActiveGamemode() != "fazbearshunt" then return end
	
	--[[
		База пилл паков внедрена в режим, потому использовать pk_pills невозможно, 
		поэтому мы чиним этот пилл пак после того как режим полностью загрузится.
	]]--

	include("include/pill_base_reignited_m.lua") -- Файл, в котором лежат данные о аниматрониках.
	
	local animatronics = { 
		["IgnitedFreddy"] = {name = "ifreddy", fullname = "Ignited Freddy", color = Color(200,200,200)},
		["IgnitedBonnie"] = {name = "igbonnie", fullname = "Ignited Bonnie", color = Color(200,200,200)},
		["IgnitedChica"] = {name = "igchica", fullname = "Ignited Chica", color = Color(200,200,200)},
		["IgnitedFoxy"] = {name = "igfoxy", fullname = "Ignited Foxy", color = Color(200,200,200)}
		["IgnitedSpringtrap"] = {name = "igspringtrap", fullname = "Ignited Springtrap", color = Color(200,200,200)}
	}
	--[[
		В квадратные скобки надо добавлять техническое имя аниматроника, указаное в файле упомянутом выше
		имя аниматроника обычно находится после pk_pills.register(...
		
		Обязательными данными аниматроников для режима являются:
		
		name	 	отвечает за нахождение иконки аниматроника для интерфейса по пути "vgui/animatronics_hud/heads/name.png" и "vgui/bars/name.png"
		fullname 	отвечает за имя аниматроника отображаемое в Админ Панели, и имя выводимое в чат при выдаче игроку
		color 		отвечает за цвет интерфейса аниматроника
	]]--
	
	for anim,tablo in pairs( animatronics ) do -- Для всех аниматроников заменяем их способности, на способности встроенных в режим аниматроников
		pk_pills.editPillTable(anim, "attack",
			{
			mode="trigger",
			func=function(ply,ent)
				if ply.lobbyFreeze != nil and ply.lobbyFreeze then return end -- Чтобы нельзя было атаковать в первую минуту игры
				
				if IsValid(ply:GetEntityInUse()) then return end -- Чтобы нельзя было атаковать с пропом в руках
				
				local target = FindNearestPlayer(ent:GetPos(), 130, ply, 90)
				if !IsValid(target) then return end
				
				ent:PillSound("melee",false) -- Звук скримера (Встроенный в Пилл)
				if target:IsNPC() then
					target:TakeDamage(target:Health(), ply)
					return 
				end
				jumpscareEvent(ply, ent, target, 50)
				ent:PillAnim("scare",true) -- ЕСЛИ У АНИМАТРОНИКА ЕСТЬ ПОДХОДЯЩАЯ АНИМАЦИЯ СКРИМЕРА, ТО ТУТ НАДО ЗАМЕНИТЬ "scare" НА НАЗВАНИЕ АНИМАЦИИ!
			
				timer.Simple( 1.6, function()
					if !IsValid(target) then return end
					target:UnLock()
					ply:UnLock()
					target:TakeDamage(target:Health(), ply)
				end)
			end
			}) -- Заменяем атаку аниматроника, на дефолтную атаку аниматроников из FH
			
		pk_pills.editPillTable(anim, "hideHud", true) -- Выключаем дефолтный интерфейс
		pk_pills.editPillTable(anim, "noFallDamage", true) -- Выключаем урон от падения
		pk_pills.editPillTable(anim, "muteSteps", true) -- Глушим звуки шагов (Игрока, не аниматроника)
		
		pk_pills.editPillTable(anim, "moveSpeed", 
			{
				walk=pk_pills.getPillTable(anim)["moveSpeed"].walk,
				run=520,
				ducked=pk_pills.getPillTable(anim)["moveSpeed"].ducked,
			}
		) -- Меняем скорость бега, так как она слишком высокая; 
		
		pk_pills.editPillTable(anim, "reload", -- Даём возможность использовать просвет
		
			function(ply,ent)
				if ply.lobbyFreeze != nil and ply.lobbyFreeze then return end
				
				HighlightPlayers(ply, ent)
			end
		)
		
		killerData[anim] = tablo -- Добавляем аниматроников в режим (НЕ ИЗМЕНЯТЬ)
		
		pill_makePreferable(anim, true) -- Добавляем аниматроников в выборку в начале раунда
		
		--pill_makeSecondary(anim, true) 
		-- Делаем аниматроника вторичным (Появляется в выборке только если аниматроников два или больше)
	end
	
end)
