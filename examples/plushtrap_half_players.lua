function plushtrap_half_players()
    local playerCount = player.GetCount()
    playerCount = playerCount / 2

    local num = 0

    for _, ply in player.Iterator() do
        if !ply:Alive() or ply:Team() == TEAM_SPECTATOR then ply:Spawn() end -- Возрождаем игроков, если они мёртвые
        giveKiller(ply, "pill_plushtrap", true)
        num = num + 1

        if num >= playerCount then break end
    end
end

