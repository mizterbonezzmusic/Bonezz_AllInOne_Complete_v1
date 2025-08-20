Config = {}

-- Chance percentages
Config.CorruptChance = 60        -- chance that /corruptdeal will actually start a deal
Config.DoubleCrossChance = 30    -- chance the dealer double-crosses (shots fired)
Config.GangInterveneChance = 40  -- chance nearby gang members join the fight when shots fired

-- Dealer NPC spawn points used for corrupt deals (near public dealers)
Config.Spots = {
  { coords = vec4(-260.0, -1388.0, 31.3, 160.0) },   -- Chamberlain UC
  { coords = vec4(65.0, -1922.0, 20.8, 180.0) },     -- Grove UC
  { coords = vec4(481.0, -1025.0, 28.3, 0.0) },      -- Mission Row UC
  { coords = vec4(383.0, 240.0, 103.0, 180.0) },     -- Vinewood UC
  { coords = vec4(-1228.0,-1292.0, 7.0, 30.0) },     -- Vespucci UC
  { coords = vec4(1936.0, 3715.0, 32.3, 220.0) },    -- Sandy UC
  { coords = vec4(-116.0, 6442.0, 31.0, 50.0) },     -- Paleto UC
}

-- Gang models used if they intervene
Config.GangUnits = {
  { model = `g_m_y_ballaorig_01`, weapon = `WEAPON_PISTOL` },
  { model = `g_m_y_mexgoon_02`,   weapon = `WEAPON_PISTOL` },
  { model = `g_m_y_korean_01`,    weapon = `WEAPON_MICROSMG` },
}
