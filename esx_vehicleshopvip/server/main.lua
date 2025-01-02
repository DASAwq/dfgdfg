local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function getVipCoins(identifier, cb)
    MySQL.scalar('SELECT vip_coins FROM users WHERE identifier = ?', {identifier}, function(coins)
        cb(coins or 0)
    end)
end

local function updateVipCoins(identifier, amount, cb)
    MySQL.update('UPDATE users SET vip_coins = vip_coins + ? WHERE identifier = ?', {amount, identifier}, function(affectedRows)
        cb(affectedRows > 0)
    end)
end

ESX.RegisterServerCallback('esx_vehicleshopvip:getVipCoins', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    getVipCoins(xPlayer.identifier, cb)
end)

ESX.RegisterServerCallback('esx_vehicleshopvip:buyVehicle', function(source, cb, model, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local vehicleData = getVehicleFromModel(model)

    if vehicleData then
        getVipCoins(xPlayer.identifier, function(coins)
            if coins >= vehicleData.price then
                updateVipCoins(xPlayer.identifier, -vehicleData.price, function(success)
                    if success then
                        MySQL.insert('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (?, ?, ?)', {
                            xPlayer.identifier,
                            plate,
                            json.encode({model = model, plate = plate})
                        }, function(rowsChanged)
                            xPlayer.showNotification(('You purchased a %s for %s VIP coins'):format(vehicleData.name, vehicleData.price))
                            cb(true)
                        end)
                    else
                        cb(false)
                    end
                end)
            else
                xPlayer.showNotification('Not enough VIP coins')
                cb(false)
            end
        end)
    else
        xPlayer.showNotification('Invalid vehicle model')
        cb(false)
    end
end)

RegisterCommand('givevipcoin', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == 'admin' then
        local targetId = tonumber(args[1])
        local amount = tonumber(args[2])

        if targetId and amount then
            local targetPlayer = ESX.GetPlayerFromId(targetId)
            if targetPlayer then
                updateVipCoins(targetPlayer.identifier, amount, function(success)
                    if success then
                        targetPlayer.showNotification(('You received %s VIP coins'):format(amount))
                        xPlayer.showNotification(('You gave %s VIP coins to %s'):format(amount, targetPlayer.getName()))
                    else
                        xPlayer.showNotification('Failed to give VIP coins')
                    end
                end)
            else
                xPlayer.showNotification('Player not found')
            end
        else
            xPlayer.showNotification('Invalid arguments')
        end
    else
        xPlayer.showNotification('Insufficient permissions')
    end
end, false)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    getVipCoins(xPlayer.identifier, function(coins)
        TriggerClientEvent('esx_vehicleshopvip:updateVipCoins', playerId, coins)
    end)
end)