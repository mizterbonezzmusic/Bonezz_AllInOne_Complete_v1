local QBCore = exports['qb-core']:GetCoreObject()

local function allowed()
    if not Config.AllowedJobs or #Config.AllowedJobs == 0 then return true end
    local pdata = QBCore.Functions.GetPlayerData()
    local job = pdata and pdata.job and pdata.job.name and pdata.job.name:lower() or nil
    if not job then return false end
    for _, j in ipairs(Config.AllowedJobs) do if j == job then return true end end
    return false
end

local function findNearestNPC(radius)
    local ped = PlayerPedId()
    local handle, npc = FindFirstPed()
    local success; local nearest, ndist = nil, radius + 0.001
    repeat
        if not IsPedAPlayer(npc) and not IsPedDeadOrDying(npc) then
            local d = #(GetEntityCoords(npc) - GetEntityCoords(ped))
            if d < ndist then nearest = npc; ndist = d end
        end
        success, npc = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return nearest
end

RegisterCommand('npccuff', function()
    if not allowed() then
        TriggerEvent('chat:addMessage', { args = {'^1Cuff', 'You are not allowed to use this.'}})
        return
    end
    local npc = findNearestNPC(Config.SearchRadius or 2.5)
    if npc then
        SetEnableHandcuffs(npc, true)
        RequestAnimDict('mp_arresting'); while not HasAnimDictLoaded('mp_arresting') do Wait(0) end
        TaskPlayAnim(npc, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, false, false, false)
        TriggerEvent('chat:addMessage', { args = {'^2Cuff', 'NPC cuffed.'}})
    else
        TriggerEvent('chat:addMessage', { args = {'^1Cuff', 'No NPC nearby.'}})
    end
end)

-- Optional qb-target hook
CreateThread(function()
    if not Config.EnableTarget then return end
    if GetResourceState('qb-target') ~= 'started' then return end
    exports['qb-target']:AddTargetModel({`a_m_m_eastsa_01`,`a_m_m_hillbilly_01`,`g_m_y_ballasout_01`,`g_m_y_mexgoon_03`,`g_m_y_korean_02`}, {
        options = {
            {
                icon = "fas fa-handcuffs",
                label = "Cuff NPC",
                action = function(entity)
                    if not allowed() then
                        TriggerEvent('chat:addMessage', { args = {'^1Cuff', 'Not allowed.'}}); return
                    end
                    SetEnableHandcuffs(entity, true)
                    RequestAnimDict('mp_arresting'); while not HasAnimDictLoaded('mp_arresting') do Wait(0) end
                    TaskPlayAnim(entity, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, false, false, false)
                    TriggerEvent('chat:addMessage', { args = {'^2Cuff', 'NPC cuffed.'}})
                end,
                canInteract = function(entity, distance, data)
                    return not IsPedAPlayer(entity) and distance < (Config.SearchRadius or 2.5)
                end
            }
        },
        distance = Config.SearchRadius or 2.5
    })
end)
