local badgeShowing = false

RegisterCommand("flashbadge", function()
    local ped = PlayerPedId()
    local playerName = GetPlayerName(PlayerId())

    RequestAnimDict("paper_1_rcm_alt1-9")
    while not HasAnimDictLoaded("paper_1_rcm_alt1-9") do
        Wait(0)
    end

    TaskPlayAnim(ped, "paper_1_rcm_alt1-9", "player_one_dual-9", 8.0, -8.0, -1, 49, 0, false, false, false)

    local label = ("[SIGNAL police] %s flashes their badge."):format(playerName)

    badgeShowing = true
    local timer = GetGameTimer() + 5000

    Citizen.CreateThread(function()
        while GetGameTimer() < timer and badgeShowing do
            local pedCoords = GetEntityCoords(ped)
            Draw3DText(pedCoords.x, pedCoords.y, pedCoords.z + 1.0, label)
            Wait(0)
        end
        badgeShowing = false
    end)
end)

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local dist = #(p - vector3(x, y, z))

    local scale = (1 / dist) * 2
    scale = scale * (1 / GetGameplayCamFov()) * 100

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
