local rob = false
local robbers = {}
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_webdev:tooFar')
AddEventHandler('esx_webdev:tooFar', function(currentStore)
	local _source = source
	local xPlayers = ESX.GetPlayers()
	rob = false

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx:showNotification', xPlayers[i], _U('robbery_cancelled_at', Stores[currentStore].nameOfStore))
			TriggerClientEvent('esx_webdev:killBlip', xPlayers[i])
		end
	end

	if robbers[_source] then
		TriggerClientEvent('esx_webdev:tooFar', _source)
		robbers[_source] = nil
		TriggerClientEvent('esx:showNotification', _source, _U('robbery_cancelled_at', Stores[currentStore].nameOfStore))
	end
end)

MySQL.ready(function()
	print("Mysql ready")
end)

RegisterServerEvent('esx_webdev:robberyStarted')
AddEventHandler('esx_webdev:robberyStarted', function(currentStore)
	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	if Stores[currentStore] then
		local store = Stores[currentStore]

		if (os.time() - store.lastRobbed) < Config.TimerBeforeNewRob and store.lastRobbed ~= 0 then
			TriggerClientEvent('esx:showNotification', _source, _U('recently_robbed', Config.TimerBeforeNewRob - (os.time() - store.lastRobbed)))
			return
		end

		local cops = 0
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				cops = cops + 1
			end
		end


		if not rob then
			local xPlayer  = ESX.GetPlayerFromId(_source)

			if xPlayer.job.name == 'webdev' then
				rob = true

				-- for i=1, #xPlayers, 1 do
					-- local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
					-- if xPlayer.job.name == 'police' then
					-- 	TriggerClientEvent('esx:showNotification', xPlayers[i], _U('rob_in_prog', store.nameOfStore))
					-- 	TriggerClientEvent('esx_webdev:setBlip', xPlayers[i], Stores[currentStore].position)
					-- end
				-- end

				TriggerClientEvent('esx:showNotification', _source, _U('started_to_rob', store.nameOfStore))
				TriggerClientEvent('esx:showNotification', _source, _U('alarm_triggered'))
				
				TriggerClientEvent('esx_webdev:currentlyRobbing', _source, currentStore)
				TriggerClientEvent('esx_webdev:startTimer', _source)
				
				Stores[currentStore].lastRobbed = os.time()
				robbers[_source] = currentStore

				local experience

				MySQL.Async.fetchAll('SELECT xp FROM webdev_xp WHERE playerid = @identifier', {
					['@identifier'] = xPlayer.getIdentifier()
				}, function (result)
					if result[1] ~= nil then
						print(result[1].xp)
						experience = result[1].xp
					else
						print("Adding new player to webdev xp table")
						MySQL.Async.execute('INSERT INTO webdev_xp (playerid, xp) VALUES (@identifier, @xp)', {
							['@identifier'] = xPlayer.getIdentifier(),
							['@xp']    = 0
						}, function()
							print("New player added to webdev xp table")
						end)
						experience = 0
					end
				end)

				SetTimeout(store.secondsRemaining * 1000, function()
					if robbers[_source] then
						rob = false

						local grade = 0

						local reward = 0
						local xp_reward = 0
						if experience >= 0 and experience < 50 then
							reward =  math.random(10, 100)
							xp_reward = math.random(1, 10)
							grade = 0
						elseif experience >= 50 and experience < 100 then
							reward =  math.random(100, 500)
							xp_reward = math.random(5, 10)
							grade = 1
						elseif experience >= 100 and experience < 250 then
							reward =  math.random(500, 1000)
							xp_reward = math.random(5, 12)
							grade = 2
						elseif experience >= 250 and experience < 500 then
							reward =  math.random(1000, 2500)
							xp_reward = math.random(6, 12)
							grade = 3
						elseif experience >= 500 then
							reward =  math.random(2500, 10000)
							xp_reward = math.random(15, 30)
							grade = 4
						end


						if xPlayer then
							TriggerClientEvent('esx_webdev:robberyComplete', _source, reward)
							xPlayer.addMoney(reward)
							TriggerClientEvent('esx:showNotification', _source, xp_reward .." XP added. Current xp: " .. experience + xp_reward)

							MySQL.Async.execute('UPDATE webdev_xp SET xp = @xp WHERE playerid = @playerid', {
								['@xp'] 			 = experience + xp_reward,
								['@playerid']        = xPlayer.getIdentifier()
							})
							
							xPlayer.setJob("webdev", grade)
							
						end
					end
				end)
			else
				TriggerClientEvent('esx:showNotification', _source, _U('min_police', Config.PoliceNumberRequired))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('robbery_already'))
		end
	end
end)
