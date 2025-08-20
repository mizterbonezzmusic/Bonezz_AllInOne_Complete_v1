
local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('bonezz:corrupt:start', function()
    local src = source
    local spot = math.random(1, #Config.Spots)
    local startDeal = (math.random(100) <= Config.CorruptChance)
    TriggerClientEvent('bonezz:corrupt:clientStart', src, spot, startDeal)
end)

RegisterNetEvent('bonezz:corrupt:exchange', function(spot, dealerNetId)
    local src = source
    -- 50/50 clean vs double-cross based on Config.DoubleCrossChance
    if math.random(100) <= Config.DoubleCrossChance then
        TriggerClientEvent('bonezz:corrupt:shootout', src, spot)
    else
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            Player.Functions.AddItem('cash', 2000)
            TriggerClientEvent('QBCore:Notify', src, "Exchange complete. Dirty cash in your pockets.", "success")
        end
    end
end)
