local isTaz = false
ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		
		if IsPedBeingStunned(GetPlayerPed(-1)) then
			
			SetPedToRagdoll(GetPlayerPed(-1), 5000, 5000, 0, 0, 0, 0)
			DisableAction()
			
		end
		
		if IsPedBeingStunned(GetPlayerPed(-1)) and not isTaz then
			
			isTaz = true
			SetTimecycleModifier("REDMIST_blend")
			ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 1.0)
			
		elseif not IsPedBeingStunned(GetPlayerPed(-1)) and isTaz then
			isTaz = false
			Wait(5000)

			if ESX.GetPlayerData().HandCuffed == 1 then

			RequestAnimDict("mp_arresting")
				while not HasAnimDictLoaded( "mp_arresting") do
					Citizen.Wait(1)
				end

			TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
			end

			SetTimecycleModifier("hud_def_desat_Trevor")
			
			Wait(10000)
			
     		SetTimecycleModifier("")
			SetTransitionTimecycleModifier("")
			StopGameplayCamShaking()
		end
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	DisableAction()
end)


function DisableAction()
	TriggerEvent("mythic_progbar:client:cancel")
end