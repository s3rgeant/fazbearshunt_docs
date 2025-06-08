hook.Add("PostGamemodeLoaded", "my_new_fh_animatronic", function()
	if engine.ActiveGamemode() != "fazbearshunt" then return end -- Если режим не Fazbear's Hunt, то ничего не делаем.
	
	killerData["pill_wgfreddyhead2"] = {name = "gfreddy", fullname = "Golden Freddy Head", color = Color(200, 200, 200)}
	--[[
		Ради примера добавляем аниматроника уже встроенного в режим, но не присутсвующего в админ панели или выборке в начале игры.

		pill_wgfreddyhead2 - Техническое имя аниматроника, используемое пилл-паком

		name - Техническое имя аниматроника, используемое интерфейсом Fazbear's Hunt
		fullname - Полное имя аниматроника
		color - Цвет интерфейса аниматроника
	]]--
	
	pill_makePreferable("pill_wgfreddyhead2", true) -- Добавляем аниматроников в выборку в начале раунда

	pill_makeSecondary("pill_wgfreddyhead2", true) 
	-- Делаем аниматроника вторичным (Появляется в выборке только если аниматроников два или больше)
end)
