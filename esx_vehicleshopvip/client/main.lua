local HasAlreadyEnteredMarker, IsInShopMenu = false, false
local CurrentAction, CurrentActionMsg, LastZone
local CurrentActionData, Vehicles, Categories = {}, {}, {}
local VIPCoins = 0

RegisterNetEvent('esx_vehicleshopvip:updateVIPCoins')
AddEventHandler('esx_vehicleshopvip:updateVIPCoins', function(coins)
    VIPCoins = coins
    ESX.ShowNotification(('You have %s VIP Coins'):format(VIPCoins))
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    TriggerServerEvent("esx_vehicleshopvip:getVehiclesAndCategories")
    TriggerServerEvent("esx_vehicleshopvip:getVIPCoins")
end)

RegisterNetEvent('esx_vehicleshopvip:updateVehiclesAndCategories', function(vehicles, categories)
    Vehicles = vehicles
    Categories = categories

    table.sort(Vehicles, function(a, b)
        return a.name < b.name
    end)
end)

function OpenVIPShopMenu()
    if #Vehicles == 0 then
        print('[^3ERROR^7] VIP Vehicleshop has ^50^7 vehicles, please add some!')
        return
    end

    IsInShopMenu = true
    ESX.UI.Menu.CloseAll()

    local elements = {}

    for i = 1, #Categories, 1 do
        local category = Categories[i]
        local categoryVehicles = {}

        for j = 1, #Vehicles, 1 do
            if Vehicles[j].category == category.name then
                table.insert(categoryVehicles, Vehicles[j])
            end
        end

        table.insert(elements, {
            name    = category.name,
            label   = category.label,
            value   = 0,
            type    = 'slider',
            max     = #categoryVehicles,
            options = categoryVehicles
        })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vip_vehicle_shop', {
        title    = 'VIP Vehicle Shop',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        local vehicleData = data.current.options[data.current.value + 1]

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
            title = ('Buy %s for %s VIP Coins?'):format(vehicleData.name, vehicleData.price),
            align = 'top-left',
            elements = {
                {label = 'No',  value = 'no'},
                {label = 'Yes', value = 'yes'}
        }}, function(data2, menu2)
            if data2.current.value == 'yes' then
                if VIPCoins >= vehicleData.price then
                    TriggerServerEvent('esx_vehicleshopvip:buyVehicle', vehicleData.model)
                    menu2.close()
                    menu.close()
                else
                    ESX.ShowNotification('Not enough VIP Coins')
                end
            else
                menu2.close()
            end
        end, function(data2, menu2)
            menu2.close()
        end)
    end, function(data, menu)
        menu.close()
        IsInShopMenu = false
    end)
end

-- Create Blips
if Config.Blip.show then
    CreateThread(function()
        local blip = AddBlipForCoord(Config.Zones.ShopEntering.Pos)

        SetBlipSprite (blip, Config.Blip.Sprite)
        SetBlipDisplay(blip, Config.Blip.Display)
        SetBlipScale  (blip, Config.Blip.Scale)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('VIP Vehicle Shop')
        EndTextCommandSetBlipName(blip)
    end)
end

-- Enter / Exit marker events & Draw Markers
CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local isInMarker, letSleep, currentZone = false, true

        for k,v in pairs(Config.Zones) do
            local distance = #(playerCoords - v.Pos)

            if distance < Config.DrawDistance then
                letSleep = false

                if v.Type ~= -1 then
                    DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
                end

                if distance < v.Size.x then
                    isInMarker, currentZone = true, k
                end
            end
        end

        if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
            HasAlreadyEnteredMarker, LastZone = true, currentZone
            LastZone = currentZone
            CurrentAction = 'vip_shop_menu'
            CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to access the VIP Vehicle Shop'
            CurrentActionData = {}
        end

        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            CurrentAction = nil
        end

        if letSleep then
            Wait(500)
        end
    end
end)

-- Key controls
CreateThread(function()
    while true do
        Wait(0)

        if CurrentAction then
            ESX.TextUI(CurrentActionMsg)

            if IsControlJustReleased(0, 38) then
                if CurrentAction == 'vip_shop_menu' then
                    OpenVIPShopMenu()
                end
                ESX.HideUI()
                CurrentAction = nil
            end
        else
            Wait(500)
        end
    end
end)