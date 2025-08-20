local QBCore = exports['qb-core']:GetCoreObject()

local function deepMerge(dst, src)
    for k, v in pairs(src) do
        if type(v) == 'table' then
            dst[k] = dst[k] or {}
            deepMerge(dst[k], v)
        else
            dst[k] = v
        end
    end
end

CreateThread(function()
    Wait(1000)
    local ok, rx = pcall(function() return LoadResourceFile('Bonezz_Rx_AllInOne_v3', 'items.lua') end)
    if not ok or not rx then
        print('[bonezz_rx_loader] items.lua not found in Bonezz_Rx_AllInOne_v3')
        return
    end
    local chunk, err = load(rx, '@items.lua', 't')
    if not chunk then
        print('[bonezz_rx_loader] load error: '..tostring(err))
        return
    end
    local env = {}
    setfenv(chunk, env)
    local ranOK, _ = pcall(chunk)
    if not ranOK then
        print('[bonezz_rx_loader] items.lua runtime error')
        return
    end
    if not env or not env.Items then
        print('[bonezz_rx_loader] items.lua did not return Items table')
        return
    end

    local items = env.Items
    local shared = QBCore.Shared.Items or {}
    for name, def in pairs(items) do
        if shared[name] == nil then
            shared[name] = def
        else
            deepMerge(shared[name], def)
        end
    end
    QBCore.Shared.Items = shared
    print(('[bonezz_rx_loader] merged %s Rx items into QBCore.Shared.Items'):format(#(function() local c=0 for _ in pairs(items) do c=c+1 end return {c} end)()[1]))
end)
