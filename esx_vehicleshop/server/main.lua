local categories, vehicles = {}, {}
local vehiclesByModel = {}

CreateThread(function()
	local char = Config.PlateLetters
	char = char + Config.PlateNumbers
	if Config.PlateUseSpace then char = char + 1 end

	if char > 8 then
		print(('[^3WARNING^7] Character Limit Exceeded, ^5%s/8^7!'):format(char))
	end
end)

RegisterNetEvent('esx_vehicleshop:buyVIPVehicle')
AddEventHandler('esx_vehicleshop:buyVIPVehicle', function(model)
    local xPlayer = ESX.GetPlayerFromId(source)
    local vehicleData = getVehicleFromModel(model)
    if vehicleData and vehicleData.vip_price and xPlayer.get('vip_coins') >= vehicleData.vip_price then
        MySQL.update('UPDATE users SET vip_coins = vip_coins - ? WHERE identifier = ?', {vehicleData.vip_price, xPlayer.identifier}, function(rowsChanged)
            if rowsChanged > 0 then
                MySQL.insert('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (?, ?, ?)', {xPlayer.identifier, 'VIP' .. math.random(1000, 9999), json.encode({model = joaat(model)})}, function()
                    xPlayer.showNotification('You have purchased a VIP vehicle.')
                    TriggerClientEvent('esx_vehicleshop:updateVIPCoins', source, xPlayer.get('vip_coins') - vehicleData.vip_price)
                end)
            end
        end)
    else
        xPlayer.showNotification('Not enough VIP coins.')
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
                MySQL.update('UPDATE users SET vip_coins = vip_coins + ? WHERE identifier = ?', {amount, targetPlayer.identifier}, function(rowsChanged)
                    if rowsChanged > 0 then
                        TriggerClientEvent('esx:showNotification', targetId, 'You have received ' .. amount .. ' VIP coins.')
                        TriggerClientEvent('esx_vehicleshop:updateVIPCoins', targetId, targetPlayer.get('vip_coins') + amount)
                    end
                end)
            end
        end
    end
end, false)

function RemoveOwnedVehicle(plate)
	MySQL.update('DELETE FROM owned_vehicles WHERE plate = ?', {plate})
end

AddEventHandler('onResourceStart', function(resourceName)
	if resourceName == GetCurrentResourceName() then
		SQLVehiclesAndCategories()
	end
end)

function SQLVehiclesAndCategories()
	categories = MySQL.query.await('SELECT * FROM vehicle_categories')
	vehicles = MySQL.query.await('SELECT vehicles.*, vehicle_categories.label AS categoryLabel, vehicles.vip_price FROM vehicles JOIN vehicle_categories ON vehicles.category = vehicle_categories.name')

	for _, vehicle in pairs(vehicles) do
		vehiclesByModel[vehicle.model] = vehicle
	end

	TriggerClientEvent("esx_vehicleshop:updateVehiclesAndCategories", -1, vehicles, categories, vehiclesByModel)
end

function getVehicleFromModel(model)
	return vehiclesByModel[model]
end

RegisterNetEvent("esx_vehicleshop:getVehiclesAndCategories", function()
	TriggerClientEvent("esx_vehicleshop:updateVehiclesAndCategories", source, vehicles, categories, vehiclesByModel)
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyVehicle', function(source, cb, model, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	local vehicleData = getVehicleFromModel(model)
	local modelPrice = vehicleData.price

	if modelPrice and xPlayer.getMoney() >= modelPrice then
		xPlayer.removeMoney(modelPrice, "Vehicle Purchase")

		MySQL.insert('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (?, ?, ?)', {xPlayer.identifier, plate, json.encode({model = joaat(model), plate = plate})
		}, function(rowsChanged)
			xPlayer.showNotification(TranslateCap('vehicle_belongs', plate))
			ESX.OneSync.SpawnVehicle(joaat(model), Config.Zones.ShopOutside.Pos, Config.Zones.ShopOutside.Heading,{plate = plate}, function(vehicle)
				Wait(100)
				local vehicle = NetworkGetEntityFromNetworkId(vehicle)
				Wait(300)
				TaskWarpPedIntoVehicle(GetPlayerPed(source), vehicle, -1)
			end)
			cb(true)
		end)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_vehicleshop:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.inventory

	cb({items = items})
end)

ESX.RegisterServerCallback('esx_vehicleshop:isPlateTaken', function(source, cb, plate)
	MySQL.scalar('SELECT plate FROM owned_vehicles WHERE plate = ?', {plate},
	function(result)
		cb(result ~= nil)
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:retrieveJobVehicles', function(source, cb, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.query('SELECT * FROM owned_vehicles WHERE owner = ? AND type = ? AND job = ?', {xPlayer.identifier, type, xPlayer.job.name},
	function(result)
		cb(result)
	end)
end)

RegisterNetEvent('esx_vehicleshop:setJobVehicleState')
AddEventHandler('esx_vehicleshop:setJobVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.update('UPDATE owned_vehicles SET `stored` = ? WHERE plate = ? AND job = ?', {state, plate, xPlayer.job.name},
	function(rowsChanged)
		if rowsChanged == 0 then
			print(('[^3WARNING^7] Player ^5%s^7 Attempted To Exploit the Garage!'):format(source, plate))
		end
	end)
end)