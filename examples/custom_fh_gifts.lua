hook.Add("OnGamemodeLoaded", "my_fh_custom_gifts", function()
	if engine.ActiveGamemode() != "fazbearshunt" then return end

	gifts.AddPositiveEffect('crowbar',
						"+ Монтировка",
						-1, 			-- Если в описании используется %i а указанное слева число равно или больше 0, то игра попробует заменить %i в описании на эту цифру.
	function(ply) 						-- Функция при получении эффекта
		ply:Give("weapon_crowbar")
	end,
	function(ply) 						-- Если у игрока нету монтировки, даём её ему.
		return !ply:HasWeapon("weapon_crowbar")
	end)
end)