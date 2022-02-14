ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_hidecar:storeHiddenVehicle')

AddEventHandler('esx_hidecar:storeHiddenVehicle', function(vehPlate, vehicleModel)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local plate =  vehPlate
	local model =  vehicleModel
	local result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier and plate = @plate', {
			['@identifier'] = xPlayer.identifier,
			['@plate'] = plate,
		})
	if #result > 0 then
		MySQL.Async.insert('INSERT INTO hidden_cars (owner, plate, model) VALUES (@owner, @plate, @model)',
		 
		{ 
		['owner'] = xPlayer.identifier, 
		['plate'] = plate, 
		['model'] = model--, 
		},
		function(insertId)
			print(insertId)
			TriggerClientEvent("esx_hidecar:CoverVehicle", _source)
		end)
	else
		TriggerClientEvent("esx:showNotification", _source, "You can only hide vehicles owned by another player!")
		TriggerClientEvent("esx:showNotification", _source, "Better take it to the chop shop.")
		
	end
end)

RegisterServerEvent('esx_hidecar:giveMoney')
AddEventHandler('esx_hidecar:giveMoney', function(earned)
    local _source = source
    local player = ESX.GetPlayerFromId(_source)
    local amount = earned
    player.addMoney(amount)
    TriggerClientEvent("esx:showNotification", source, ("You get $%s"):format(amount).. " for the vehicle")
end)

RegisterServerEvent('esx_hidecar:addVehicle')
AddEventHandler('esx_hidecar:addVehicle', function(plate)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local vehPlate = plate
	local CashonHand = xPlayer.getMoney()
	
	if CashonHand < 1500 then	
		xPlayer.showNotification('~y~You do not have enough money', false, yes, 140)
	else	
		xPlayer.removeMoney(1500)
		MySQL.Async.execute('UPDATE owned_vehicles SET owner = @owner, job = @job, stored = 1 WHERE plate = @plate', {
		['@owner'] = xPlayer.identifier,
		['@job'] = xPlayer.job.name,
		['@plate'] = vehPlate
		}, function(rowsChanged)
			if rowsChanged then
				TriggerClientEvent("esx:showNotification", _source, ("The vehicle is yours now!"))
				MySQL.Async.execute('DELETE FROM hidden_cars WHERE plate = @plate', {
					['@plate'] = vehPlate
				})
			end
		end)		
	end
end)

ESX.RegisterServerCallback('esx_hidecar:getHiddenCarList', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local result = MySQL.Sync.fetchAll('SELECT * FROM hidden_cars WHERE owner = @identifier', {
			['@identifier'] = xPlayer.identifier
		})
	print(result[1])
	cb(result)
end)