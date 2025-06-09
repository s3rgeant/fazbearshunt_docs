hook.Add("fh_prestartgame", "golden_freddy_round", function(sprRound)
	if math.random(1,10) == 1 then -- С шансом 10%, наш код ниже сработает
		local players = player.GetAll() -- Получаем список игроков
	
		for k, v in pairs(lastKillers) do
			table.RemoveByValue(players, k)
		end
		
		players = fh.GetEarnedKiller(players) -- Убираем из списка игроков, которые в один из прошлых прошлых раундов побывали на роли убийцы.
		
		local chosenPlayer = fh.randomChoice(players) -- Выбираем случайного игрока из получившегося списка.
		
		giveKiller(chosenPlayer, 'pill_wgfreddy2', true) -- Выдаём случайному игроку Золотого Фредди
		
		animatronics[chosenPlayer] = true
		survivors[chosenPlayer] = nil
		chosenPlayer:SetTeam(2701)
		chosenPlayer:Spawn()
		
		if !lastKillers[chosenPlayer] then
			lastKillers[chosenPlayer] = 0
		end
		
		chosenPlayer:Freeze(true) -- Замораживаем аниматроников
		chosenPlayer.lobbyFreeze = true
      
		timer.Create("fh_unfreeze_gfreddy", setupGameDuration, 1, function() -- Размораживаем аниматроников через минуту после начала раунда
			for ply, _ in pairs( animatronics ) do
				ply.lobbyFreeze = nil
				ply:Freeze(false)
			end
			roundActive = true
			LogEvent(" ")
			LogEvent("(*АВТО*) - Золотой Фредди разморожен, раунд начат.")
		end)
	
		hook.Run("fh_startgame", roundType, springtrapRound)
	
		net.Start("fh_start_game_timer") -- Включаем встроенный в режим таймер
		net.WriteFloat(gameDuration)
		net.WriteFloat(setupGameDuration)
		net.WriteString("ambient/alarms/warningbell1.wav")
		net.WriteString(tostring(fh.GetRoundCount()))
		net.Broadcast()
		
		net.Start('fh_adv_sound_play') -- Включаем встроенную музыку в начале раунда
		net.WriteString('music/first_minute.wav')
		net.Broadcast()
		
		timer.Create("EndGameTimer", gameDuration + setupGameDuration, 1, function()
			survivorsWin()
		end)
		
		return false
	end
end)
