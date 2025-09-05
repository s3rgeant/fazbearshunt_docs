function plushtrap_half_players()
	local players = player.GetAll()
	table.Shuffle(players)

	local halfCount = math.floor(#players / 2)

	for i = 1, halfCount do
		local ply = players[i]
		if IsValid(ply) then
			giveKiller(ply, "pill_plushtrap", true)
			ply:ReturnToSpawn()
		end
	end
end



