hook.Add("fh_prestartgame", "golden_freddy_round", function(sprRound)
	if math.random(1,10) == 1 then -- С шансом 10%, наш код ниже сработает
		local players = player.GetAll() -- Получаем список игроков
		
		players = fh.GetEarnedKillers(players) -- Убираем из списка игроков, которые в один из прошлых прошлых раундов побывали на роли убийцы.
		
		local chosenPlayer = fh.randomChoice(players) -- Выбираем случайного игрока из получившегося списка.
		
		giveKiller(chosenPlayer, 'pill_wgfreddy2', false) -- Выдаём случайному игроку Золотого Фредди
		
		chosenPlayer:ReturnToSpawn()
		
		local id = GetPlyID(chosenPlayer)
		if id and not lastKillers[id] then
			lastKillers[id] = 0
		end
      
		freezeAnimatronics()
	
		hook.Run("fh_startgame", roundType, springtrapRound)
			
		for _, ply in player.Iterator() do
			ply:SetJumpBoostMultiplier( getScaledJumpBoost() )
		end
	
		net.Start("fh_start_game_timer") -- Включаем встроенный в режим таймер
		net.WriteFloat( fh.GetGameDuration() )
		net.WriteFloat(setupGameDuration)
		net.WriteString("ambient/alarms/warningbell1.wav")
		net.WriteString(tostring(fh.GetRoundCount()))
		net.Broadcast()
		
		net.Start('fh_adv_sound_play') -- Включаем встроенную музыку в начале раунда
		net.WriteString( "#"..fh.GetRoundMusic( fh.GetRoundType() ) )
		net.WriteString( "timer_music" )
		net.Broadcast()
		
		timer.Create("EndGameTimer", gameDuration + setupGameDuration, 1, function()
			survivorsWin()
		end)
		
		return false
	end
end)
