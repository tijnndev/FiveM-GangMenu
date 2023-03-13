local PlayerData = {}
ESX = nil
local xPlayer, job

Citizen.CreateThread(
	function()
		while ESX == nil do
			TriggerEvent(
				"esx:getSharedObject",
				function(obj)
					ESX = obj
				end
			)
			Citizen.Wait(0)
			PlayerData = ESX.GetPlayerData()
		end
	end
)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
	"esx:playerLoaded",
	function(xPlayer)
		PlayerData = ESX.GetPlayerData()
	end
)

RegisterNetEvent("esx:setJob")
AddEventHandler(
	"esx:setJob",
	function(job)
		PlayerData.job = job
	end
)

function OpenMenu()
	local playerPed = PlayerPedId()
	ESX.UI.Menu.Open(
		"default",
		GetCurrentResourceName(),
		"wapendealer",
		{
			title = "Gang",
			align = "top-right",
			elements = {
				{label = _U("tie"), value = "tie"},
				{label = _U("search"), value = "search"},
				{label = _U("drag"), value = "drag"},
				{label = _U("put_in_vehicle"), value = "put_in_vehicle"},
				{label = _U("out_the_vehicle"), value = "out_the_vehicle"},
				{label = _U("id_card"), value = "id_card"},
				{label = _U("crack_vehicle"), value = "crack_vehicle"},
				{label = _U("back"), value = "close"}
			}
		},
		function(data, menu)
			if (data.current.value == nil or data.current.value == "") then
				return
			end
			if (data.current.value == "tie") then
				HandcuffPlayer()
			elseif (data.current.value == "search") then
				OpenPlayerInventory()
			elseif (data.current.value == "drag") then
				DragPlayer()
			elseif (data.current.value == "put_in_vehicle") then
				OpenPutInVehicle()
			elseif (data.current.value == "out_the_vehicle") then
				OpenPutOutVehicle()
			elseif (data.current.value == "id_card") then
				OpenIDCard()
			elseif (data.current.value == "crack_vehicle") then
				HijackVehicle()
			elseif data.current.value == "close" then
				ESX.UI.Menu.CloseAll()
			end
		end,
		function()
			ESX.UI.Menu.CloseAll()
		end
	)
end
function HandcuffPlayer()
	local targetPlayer, targetDistance = ESX.Game.GetClosestPlayer()

	if (targetPlayer == -1 or targetDistance > 5) then
		ESX.ShowNotification(_U("no_player_close"))
		return
	end

	ESX.TriggerServerCallback(
		"td_" .. Config.JobName .. "job:handcuffPlayer",
		function()
		end,
		GetPlayerServerId(targetPlayer)
	)
end

function DragPlayer()
	local targetPlayer, targetDistance = ESX.Game.GetClosestPlayer()

	if (targetPlayer == -1 or targetDistance > 5) then
		ESX.ShowNotification(_U("no_player_close"))
		return
	end

	ESX.TriggerServerCallback(
		"td_" .. Config.JobName .. "job:drag",
		function()
		end,
		GetPlayerServerId(targetPlayer)
	)
end

RegisterNetEvent("sb_" .. Config.JobName .. "job:handcuff")
AddEventHandler(
	"sb_" .. Config.JobName .. "job:handcuff",
	function()
		IsHandcuffed = not IsHandcuffed
		local playerPed = PlayerPedId()

		Citizen.CreateThread(
			function()
				if IsHandcuffed then
					RequestAnimDict("mp_arresting")
					while not HasAnimDictLoaded("mp_arresting") do
						Citizen.Wait(100)
					end

					TaskPlayAnim(playerPed, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)

					SetEnableHandcuffs(playerPed, true)
					DisablePlayerFiring(playerPed, true)
					SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true) -- unarm player
					SetPedCanPlayGestureAnims(playerPed, false)
					FreezeEntityPosition(playerPed, true)
					DisplayRadar(false)

					if Config.EnableHandcuffTimer then
						if HandcuffTimer.Active then
							ESX.ClearTimeout(HandcuffTimer.Task)
						end

						StartHandcuffTimer()
					end
				else
					if Config.EnableHandcuffTimer and HandcuffTimer.Active then
						ESX.ClearTimeout(HandcuffTimer.Task)
					end

					ClearPedSecondaryTask(playerPed)
					SetEnableHandcuffs(playerPed, false)
					DisablePlayerFiring(playerPed, false)
					SetPedCanPlayGestureAnims(playerPed, true)
					FreezeEntityPosition(playerPed, false)
					DisplayRadar(true)
				end
			end
		)
	end
)

RegisterNetEvent("sb_" .. Config.JobName .. "job:drag")
AddEventHandler(
	"sb_" .. Config.JobName .. "job:drag",
	function(dragger)
		DraggedBy = dragger
		Drag = not Drag
	end
)

local open = false

Citizen.CreateThread(
	function()
		while true do
			Wait(0)
			if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then
				SendNUIMessage(
					{
						action = "close"
					}
				)
				open = false
			end
		end
	end
)

Citizen.CreateThread(
	function()
		while true do
			Citizen.Wait(0)
			if IsControlJustReleased(0, 167) and PlayerData.job.name == "gang" then
				OpenMenu()
			end
		end
	end
)

AddEventHandler(
	"onResourceStop",
	function()
		SendNUIMessage(
			{
				action = "close"
			}
		)
		ESX.UI.Menu.CloseAll()
	end
)
