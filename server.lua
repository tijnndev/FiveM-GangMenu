local ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "td_" .. Config.Jobname .. "job:handcuffPlayer",
    function(source, cb, targetPlayer)
        local xPlayer = ESX.GetPlayerFromId(source)
        local xTarget = ESX.GetPlayerFromId(targetPlayer)
        TriggerClientEvent("td_" .. Config.Jobname .. "job:handcuff", xTarget.source)
        cb()
    end
)

ESX.RegisterServerCallback(
    "td_" .. Config.Jobname .. "job:drag",
    function(source, cb, targetPlayer)
        local xPlayer = ESX.GetPlayerFromId(source)
        local xTarget = ESX.GetPlayerFromId(targetPlayer)
        TriggerClientEvent("td_" .. Config.Jobname .. "job:drag", xTarget.source, source)
        cb()
    end
)

function GetOnlinePlayers()
    local xPlayers = ESX.GetPlayers()
    local players = {}

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        table.insert(
            players,
            {
                source = xPlayer.source,
                identifier = xPlayer.identifier,
                name = xPlayer.name,
                job = xPlayer.job,
                job = xPlayer.job
            }
        )
    end

    return players
end
