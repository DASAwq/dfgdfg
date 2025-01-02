local VIPCoins = {}

-- Load player VIP coins from the database when they join
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    local result = MySQL.scalar.await('SELECT coins FROM vip_coins WHERE player_id = ?', {xPlayer.identifier})
    VIPCoins[playerId] = result or 0
    TriggerClientEvent('esx_vehicleshopvip:updateVIPCoins', playerId, VIPCoins[playerId])
end)

-- Command to give VIP coins to a player
ESX.RegisterCommand('givevipcoin', 'admin', function(xPlayer, args, showError)
    local targetPlayer = ESX.GetPlayerFromId(args.playerId)
    if targetPlayer then
        VIPCoins[args.playerId] = (VIPCoins[args.playerId] or 0) + args.amount
        MySQL.update('UPDATE vip_coins SET coins = ? WHERE player_id = ?', {VIPCoins[args.playerId], targetPlayer.identifier})
        TriggerClientEvent('esx_vehicleshopvip:updateVIPCoins', args.playerId, VIPCoins[args.playerId])
        xPlayer.showNotification(('Gave %s VIP Coins to %s'):format(args.amount, targetPlayer.getName()))
    else
        showError('Player not found')
    end
end, true, {help = 'Give VIP coins to a player', validate = true, arguments = {
    {name = 'playerId', help = 'Player ID', type = 'player'},
    {name = 'amount', help = 'Amount of VIP coins', type = 'number'}
}})

-- Handle vehicle purchase
RegisterNetEvent('esx_vehicleshopvip:buyVehicle')
AddEventHandler('esx_vehicleshopvip:buyVehicle', function(model)
    local xPlayer = ESX.GetPlayerFromId(source)
    local vehicleData = MySQL.single.await('SELECT * FROM vip_vehicles WHERE model = ?', {model})

    if vehicleData and VIPCoins[source] >= vehicleData.price then
        VIPCoins[source] = VIPCoins[source] - vehicleData.price
        MySQL.update('UPDATE vip_coins SET coins = ? WHERE player_id = ?', {VIPCoins[source], xPlayer.identifier})
        MySQL.insert('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (?, ?, ?)', {
            xPlayer.identifier,
            GeneratePlate(),
            json.encode({model = model, plate = plate})
        }, function(rowsChanged)
            xPlayer.showNotification(('You purchased a %s'):format(vehicleData.name))
            TriggerClientEvent('esx_vehicleshopvip:updateVIPCoins', source, VIPCoins[source])
        end)
    else
        xPlayer.showNotification('Not enough VIP Coins')
    end
end)

-- Utility function to get vehicle data from model
function getVehicleFromModel(model)
    local result = MySQL.single.await('SELECT * FROM vehicles WHERE model = ?', {model})
    return result
end