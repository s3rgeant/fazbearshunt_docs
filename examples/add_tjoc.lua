hook.Add("PostGamemodeLoaded", "fh_test_tjoc", function()
	if engine.ActiveGamemode() != "fazbearshunt" then return end
	
	--[[
		База пилл паков внедрена в режим, потому использовать pk_pills невозможно, 
		поэтому мы чиним этот пилл пак после того как режим полностью загрузится.
	]]--

	include("autorun/include/pill_reignited_m.lua") -- Файл, в котором лежат данные о аниматрониках.
	
	local animatronics = { 
		["IgnitedFreddy"] = {name = "ifreddy", fullname = "Ignited Freddy", color = Color(200,200,200)},
		["IgnitedBonnie"] = {name = "igbonnie", fullname = "Ignited Bonnie", color = Color(200,200,200)},
		["IgnitedChica"] = {name = "igchica", fullname = "Ignited Chica", color = Color(200,200,200)},
		["IgnitedFoxy"] = {name = "igfoxy", fullname = "Ignited Foxy", color = Color(200,200,200)},
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
		pills.editPillTable(anim, "attack",
			{
			mode="trigger",
			func=function(ply,ent)
				if IsValid(ply:GetEntityInUse()) then return end
				
				local target = FindNearestPlayer(ent:GetPos(), 130, ply, 90)
				
				if !IsValid(target) then 
					AnimatronicBreakProp(ply, ent)
					return 
				end
				
				performJumpscare(ply, ent, target, 1.6, "", 50, "")
			end
			}) -- Заменяем атаку аниматроника, на дефолтную атаку аниматроников из FH
			
		pills.editPillTable(anim, "hideHud", true) -- Выключаем дефолтный интерфейс
		pills.editPillTable(anim, "noFallDamage", true) -- Выключаем урон от падения
		pills.editPillTable(anim, "muteSteps", true) -- Глушим звуки шагов (Игрока, не аниматроника)
		
		pills.editPillTable(anim, "moveSpeed", 
			{
				walk=pills.getPillTable(anim)["moveSpeed"].walk,
				run=520,
				ducked=pills.getPillTable(anim)["moveSpeed"].ducked,
			}
		) -- Меняем скорость бега, так как она слишком высокая, скорость ходьбы и ползанья не трогаем; 
		
		pills.editPillTable(anim, "reload", -- Даём возможность использовать просвет
			function(ply,ent)
				highlight.ByDistance(ply, ent)
			end
		)
		
		killerData[anim] = tablo -- Добавляем аниматроников в режим (НЕ ИЗМЕНЯТЬ)
		
		pill_makePreferable(anim, true) -- Добавляем аниматроников в выборку в начале раунда
		
		--pill_makeSecondary(anim, true) 
		-- Делаем аниматроника вторичным (Появляется в выборке только если аниматроников два или больше)
	end
	
end)



