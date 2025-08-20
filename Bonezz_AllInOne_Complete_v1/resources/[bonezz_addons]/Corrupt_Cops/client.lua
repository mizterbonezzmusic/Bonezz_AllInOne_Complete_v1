
local QBCore = exports['qb-core']:GetCoreObject()

local function DrawText3D(x, y, z, text)
    SetDrawOrigin(x, y, z, 0)
    SetTextFont(4)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

local function spawnPed(model, coords)
    RequestModel(model); while not HasModelLoaded(model) do Wait(0) end
    local ped = CreatePed(4, model, coords.x, coords.y, coords.z-1.0, coords.w or 0.0, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, false)
    return ped
end

RegisterCommand('corruptdeal', function()
    local pdata = QBCore.Functions.GetPlayerData()
    if not pdata or not pdata.job or not pdata.job.name then
        QBCore.Functions.Notify("No job data.", "error"); return
    end
    local job = pdata.job.name:lower()
    if not (job == 'police' or job == 'sheriff' or job == 'state' or job == 'lspd' or job == 'bcso') then
        QBCore.Functions.Notify("Only LEO can start a corrupt deal.", "error"); return
    end
    TriggerServerEvent('bonezz:corrupt:start')
end)

RegisterNetEvent('bonezz:corrupt:clientStart', function(spot, startDeal)
    if not startDeal then
        QBCore.Functions.Notify("No opportunity for a corrupt deal right now.", "error"); return
    end
    local ped = PlayerPedId()
    local s = Config.Spots[spot]
    local dealer = spawnPed(`s_m_y_dealer_01`, s.coords)
    TaskStartScenarioInPlace(dealer, "WORLD_HUMAN_DRUG_DEALER", 0, true)

    local pos = vector3(s.coords.x, s.coords.y, s.coords.z)
    local inRange = false
    while #(GetEntityCoords(ped) - pos) > 2.0 do
        DrawMarker(2, s.coords.x, s.coords.y, s.coords.z+0.1, 0,0,0, 0,0,0, 0.2,0.2,0.2, 0,200,0, 120, false,true,2,false,nil,nil,false)
        Wait(0)
    end
    DrawText3D(s.coords.x, s.coords.y, s.coords.z+1.0, "~g~E~w~ to make the exchange")
    local ok = false
    while true do
        Wait(0)
        if IsControlJustPressed(0, 38) then
            ok = true
            break
        end
    end
    if ok then
        TriggerServerEvent('bonezz:corrupt:exchange', spot, NetworkGetNetworkIdFromEntity(dealer))
    end
end)

RegisterNetEvent('bonezz:corrupt:shootout', function(spot)
    local s = Config.Spots[spot]
    local ped = PlayerPedId()
    local pos = vector3(s.coords.x, s.coords.y, s.coords.z)
    -- Dealer turns hostile
    local attacker = spawnPed(`g_m_y_mexgoon_03`, s.coords); GiveWeaponToPed(attacker, `WEAPON_PISTOL`, 100, false, true)
    TaskCombatPed(attacker, ped, 0, 16)
    -- Optional gang intervention
    if math.random(100) <= Config.GangInterveneChance then
        for i=1, math.random(2, 4) do
            local offset = vector3(pos.x + math.random(-15,15), pos.y + math.random(-15,15), pos.z)
            local unit = spawnPed(`g_m_y_ballaorig_01`, vec4(offset.x, offset.y, offset.z, 0.0))
            GiveWeaponToPed(unit, `WEAPON_PISTOL`, 100, false, true)
            TaskCombatPed(unit, ped, 0, 16)
        end
        QBCore.Functions.Notify("Gang members have intervened!", "error")
    else
        QBCore.Functions.Notify("The dealer double-crossed you!", "error")
    end
end)
