local QBCore = exports["qb-core"]:GetCoreObject()


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.Paivitysaika*1000)
        if Config.Viesti == "" then 
            lahetaviesti()
            break
        else
            paivita()
        end
    end
end)


function lahetaviesti()
    local embedi = {
        {
            ["color"] = Config.Vari,
            ["title"] = "Pelaajia: 0\nPoliiseja: 0\nEnsihoitajia: 0\nMekaanikkoja: 0"
        }
    }
    PerformHttpRequest(Config.Webhookki, function(err, text, header) end, 'POST', json.encode({embeds = embedi, avatar_url = Config.Avatari}), {['Content-Type'] = 'application/json'})
end


function paivita()
    local poliiseja, ensihoitajia, mekaanikkoja = 0, 0, 0
    local maximipelaajat = GetConvarInt("sv_maxclients", 32)
    local pelaajat = #GetPlayers()
    local qbpelaajat = QBCore.Functions.GetQBPlayers()
    for k, v in pairs(qbpelaajat) do
        if (v.PlayerData.job.name == "police") then
            poliiseja = poliiseja + 1
        elseif (v.PlayerData.job.name == "ambulance") then
            ensihoitajia = ensihoitajia + 1
        elseif (v.PlayerData.job.name == "mechanic") then
            mekaanikkoja = mekaanikkoja + 1
        end
    end
    local embedi = {
        {
            ["color"] = Config.Vari,
            ["title"] = ":bust_in_silhouette:Pelaajia: "..pelaajat.."/"..maximipelaajat.."\n:police_car:Poliiseja: "..poliiseja.."\n:ambulance:Ensihoitajia: "..ensihoitajia.."\n:mechanic:Mekaanikkoja: "..mekaanikkoja..""
        }
    }
    PerformHttpRequest(Config.Webhookki.."/messages/"..Config.Viesti, function(err, text, header) end, 'PATCH', json.encode({embeds = embedi, avatar_url = Config.Avatari}), {['Content-Type'] = 'application/json'})
end