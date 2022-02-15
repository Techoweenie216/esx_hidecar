ESX              = nil
local PlayerData = {}
local hidecar = no
HasAlreadyGotMessage = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer 
			 
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterCommand('hidecar', function(source, args)
		
	local ped = PlayerPedId()
	local playerCoords = GetEntityCoords(ped)
	local heading = GetEntityHeading(ped)
	local x,y,z = table.unpack(GetEntityCoords(ped, true))
	local vehicle = GetVehiclePedIsIn(ped, false)
	local class = GetVehicleClass(vehicle)
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)	
	local vehplate = vehicleProps.plate
	local vehiclemodel = vehicleProps.model

	if vehicle == 0 then	
		TriggerEvent('chat:addMessage', 'You are not in a vehicle.')
		HasAlreadyGotMessage = true
	else	
		TriggerServerEvent('esx_hidecar:storeHiddenVehicle', vehplate, vehiclemodel)
	end
end)

RegisterNetEvent('esx_hidecar:CoverVehicle')
AddEventHandler('esx_hidecar:CoverVehicle', function(source,args)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	local class = GetVehicleClass(vehicle)
	local x,y,z = table.unpack(GetEntityCoords(ped, true))

	-- ped gets out of vehicle
		TaskLeaveVehicle(ped,vehicle,64)
		Citizen.Wait(2000)

	-- find the type of vehicle and cover it	
		if class == 0 then
			local objectname = 'imp_prop_covered_vehicle_02a'
            RequestModel(objectname)
            while not HasModelLoaded(objectname) do
				Citizen.Wait(1)
            end
		DeleteVehicle(vehicle)
		Citizen.Wait(200)
		local obj = CreateObject(GetHashKey(objectname), x, y, z, true, false)
		SetEntityHeading(obj, heading)
		PlaceObjectOnGroundProperly(obj)
		end

		if class == 1 then
			local objectname = 'imp_prop_covered_vehicle_03a'
            RequestModel(objectname)
            while not HasModelLoaded(objectname) do
                Citizen.Wait(1)
            end
		DeleteVehicle(vehicle)
		Citizen.Wait(200)
		local obj = CreateObject(GetHashKey(objectname), x, y, z, true, false)
		SetEntityHeading(obj, heading)
		PlaceObjectOnGroundProperly(obj)
		end
	
		if class == 2 then
			local objectname = 'imp_prop_covered_vehicle_07a'
            RequestModel(objectname)
            while not HasModelLoaded(objectname) do
                Citizen.Wait(1)
            end
		DeleteVehicle(vehicle)
		Citizen.Wait(200)
		local obj = CreateObject(GetHashKey(objectname), x, y, z, true, false)
		SetEntityHeading(obj, heading)
		PlaceObjectOnGroundProperly(obj)
		end

		if class == 3 then
			local objectname = 'imp_prop_covered_vehicle_01a'
                RequestModel(objectname)
                while not HasModelLoaded(objectname) do
                  Citizen.Wait(1)
                end
		DeleteVehicle(vehicle)
		Citizen.Wait(200)
		local obj = CreateObject(GetHashKey(objectname), x, y, z, true, false)
		SetEntityHeading(obj, heading)
		PlaceObjectOnGroundProperly(obj)
		end

		if class == 4 then
			local objectname = 'imp_prop_covered_vehicle_04a'
                RequestModel(objectname)
                while not HasModelLoaded(objectname) do
                  Citizen.Wait(1)
                end
		DeleteVehicle(vehicle)
		Citizen.Wait(200)
		local obj = CreateObject(GetHashKey(objectname), x, y, z, true, false)
		SetEntityHeading(obj, heading)
		PlaceObjectOnGroundProperly(obj)
		end	

		if class == 5 then
			local objectname = 'imp_prop_covered_vehicle_06a'
                RequestModel(objectname)
                while not HasModelLoaded(objectname) do
                  Citizen.Wait(1)
                end
		DeleteVehicle(vehicle)
		Citizen.Wait(200)
		local obj = CreateObject(GetHashKey(objectname), x, y, z, true, false)
		SetEntityHeading(obj, heading)
		PlaceObjectOnGroundProperly(obj)
		end	


		if class == 6 then
			local objectname = 'imp_prop_covered_vehicle_03a'
                RequestModel(objectname)
                while not HasModelLoaded(objectname) do
                  Citizen.Wait(1)
                end
		DeleteVehicle(vehicle)
		Citizen.Wait(200)
		local obj = CreateObject(GetHashKey(objectname), x, y, z, true, false)
		SetEntityHeading(obj, heading)
		PlaceObjectOnGroundProperly(obj)
		end	

		if class == 7 then
			local objectname = 'imp_prop_covered_vehicle_01a'
                RequestModel(objectname)
                while not HasModelLoaded(objectname) do
                  Citizen.Wait(1)
                end
		DeleteVehicle(vehicle)
		Citizen.Wait(200)
		local obj = CreateObject(GetHashKey(objectname), x, y, z, true, false)
		SetEntityHeading(obj, heading)
		PlaceObjectOnGroundProperly(obj)
		end
	Citizen.Wait(100)
			

end)

function fixDMVFiles()
	local markerPos = vector3(1159.948, -3199.143, -39.0)
	ESX.Game.Utils.DrawText3D(markerPos, "Press ~y~[H]~w~ to access the DMV Computer.", 1, 4)

		-- press H key    
		if IsControlJustReleased(0, 74) then 
			local dict = 'missheist_jewel@hacking'
			local anim = 'hack_loop'
			local ped = PlayerPedId()
			local time = 2500
			--play hacking animation
			RequestAnimDict(dict)

			while not HasAnimDictLoaded(dict) do
			Citizen.Wait(7)
			end

			TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 0, 0, 0, 0, 0)
			Citizen.Wait(time)
			ClearPedTasks(ped)
			
			-- pull up hidden/stolen cars
			-- cars not owner by players cannot be transferred and can only be sold to the chop shop
			ListStolenCars()
		end		
end

function ListStolenCars()
	ESX.TriggerServerCallback('esx_hidecar:getHiddenCarList', function(carList)
		if #carList then
			local elements = {}
			for k,v in pairs(carList) do
				table.insert(elements, {label = "Plate: "..v.plate.." - Car: ".. GetLabelText(GetDisplayNameFromVehicleModel(v.model)), plate = v.plate})
			end
			openStolenMenu(elements)
		else
			ESX.ShowNotification('You havent stolen any vehicle')
		end
	end)
end

function openStolenMenu(elements)
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'hidden_vehicles', {
		title    = 'Vehicles - $1500 to transfer',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()
		TriggerServerEvent('esx_hidecar:addVehicle', data.current.plate)
	end, function(data, menu)
		menu.close()
	end)
end

function checkClassOfCar(class)
	local heading = GetEntityHeading(chopshop2)
	 x,y,z = table.unpack(GetEntityCoords(chopshop2, true))

	if class == 0 then
		local objectname = 'imp_prop_covered_vehicle_02a'
                RequestModel(objectname)
                while not HasModelLoaded(objectname) do
                  Citizen.Wait(1)
                end
		DeleteVehicle(vehicle)
		Citizen.Wait(200)
		local obj = CreateObject(GetHashKey(objectname), x, y, z, true, false)
		SetEntityHeading(obj, heading)
		PlaceObjectOnGroundProperly(obj)
		DeletePed(chopshop2)
		-- get paid
		TriggerServerEvent("esx_hidecar:giveMoney", 500)
	end

	if class == 1 then
		local objectname = 'imp_prop_covered_vehicle_03a'
                RequestModel(objectname)
                while not HasModelLoaded(objectname) do
                  Citizen.Wait(1)
                end
		DeleteVehicle(vehicle)
		Citizen.Wait(200)
		local obj = CreateObject(GetHashKey(objectname), x, y, z, true, false)
		SetEntityHeading(obj, heading)
		PlaceObjectOnGroundProperly(obj)
		DeletePed(chopshop2)
		-- get paid
		TriggerServerEvent("esx_hidecar:giveMoney", 750)
	end
	
	if class == 2 then
		local objectname = 'imp_prop_covered_vehicle_07a'
                RequestModel(objectname)
                while not HasModelLoaded(objectname) do
                  Citizen.Wait(1)
                end
		DeleteVehicle(vehicle)
		Citizen.Wait(200)
		local obj = CreateObject(GetHashKey(objectname), x, y, z, true, false)
		SetEntityHeading(obj, heading)
		PlaceObjectOnGroundProperly(obj)
		DeletePed(chopshop2)
		-- get paid
		TriggerServerEvent("esx_hidecar:giveMoney", 1000)
	end

	if class == 3 then
		local objectname = 'imp_prop_covered_vehicle_01a'
                RequestModel(objectname)
                while not HasModelLoaded(objectname) do
                  Citizen.Wait(1)
                end
		DeleteVehicle(vehicle)
		Citizen.Wait(200)
		local obj = CreateObject(GetHashKey(objectname), x, y, z, true, false)
		SetEntityHeading(obj, heading)
		PlaceObjectOnGroundProperly(obj)
		DeletePed(chopshop2)
		-- get paid
		TriggerServerEvent("esx_hidecar:giveMoney", 1250)
		
	end

	if class == 4 then
		
		local objectname = 'imp_prop_covered_vehicle_04a'
                RequestModel(objectname)
                while not HasModelLoaded(objectname) do
                  Citizen.Wait(290)
                end
		
		DeleteVehicle(vehicle)
		Citizen.Wait(200)
		local obj = CreateObject(GetHashKey(objectname), x, y, z, true, false)
		SetEntityHeading(obj, heading)
		PlaceObjectOnGroundProperly(obj)
		DeletePed(chopshop2)
		-- get paid
		TriggerServerEvent("esx_hidecar:giveMoney", 2500)
	end	

	if class == 5 then
		local objectname = 'imp_prop_covered_vehicle_06a'
                RequestModel(objectname)
                while not HasModelLoaded(objectname) do
                  Citizen.Wait(1)
                end
		DeleteVehicle(vehicle)
		Citizen.Wait(200)
		local obj = CreateObject(GetHashKey(objectname), x, y, z, true, false)
		SetEntityHeading(obj, heading)
		PlaceObjectOnGroundProperly(obj)
		DeletePed(chopshop2)
		-- get paid
		TriggerServerEvent("esx_hidecar:giveMoney", 2750)
	end	


	if class == 6 then
		local objectname = 'imp_prop_covered_vehicle_03a'
                RequestModel(objectname)
                while not HasModelLoaded(objectname) do
                  Citizen.Wait(1)
                end
		DeleteVehicle(vehicle)
		Citizen.Wait(200)
		local obj = CreateObject(GetHashKey(objectname), x, y, z, true, false)
		SetEntityHeading(obj, heading)
		PlaceObjectOnGroundProperly(obj)
		DeletePed(chopshop2)
		-- get paid
		TriggerServerEvent("esx_hidecar:giveMoney", 3000)
	end	

	if class == 7 then
		local objectname = 'imp_prop_covered_vehicle_01a'
                RequestModel(objectname)
                while not HasModelLoaded(objectname) do
                	Citizen.Wait(1)
                end
		DeleteVehicle(vehicle)
		Citizen.Wait(200)
		local obj = CreateObject(GetHashKey(objectname), x, y, z, true, false)
		SetEntityHeading(obj, heading)
		PlaceObjectOnGroundProperly(obj)
		DeletePed(chopshop2)
		-- get paid
		TriggerServerEvent("esx_hidecar:giveMoney", 3250)
	end	
end

function chopcar()
	local ped = PlayerPedId()
	local markerPos = vector3(2340.852, 3126.44, 48.21)
	vehicle = GetLastDrivenVehicle(ped)
	class = GetVehicleClass(vehicle)

	ESX.Game.Utils.DrawText3D(markerPos, "Press ~y~[H]~w~ to Scrap this car.", 2, 4)

	-- press H key    
	if IsControlJustReleased(0, 74) then
	
		areYouIn = IsVehicleSeatFree(vehicle,-1)	
		Citizen.Wait(500)
		PlayPedAmbientSpeechNative(chopshop1, 'Generic_Thanks', 'Speech_Params_Force_Shouted_Critical')
		
		if areYouIn == 1 then
			-- spawn helper
			RequestModel(0x7B0E452F)
			chopshop2 = CreatePed(30, 0x7B0E452F, 2344.011, 3142.448, 48.20875, 173.43, true, false)
			Citizen.Wait(200)
		
			-- helper gets in vehicle
			TaskEnterVehicle(chopshop2, vehicle, -1, -1, 1.5, 1.0, 0)
			SetDriverAbility(chopshop2, 1.0) 

			--gets 10 sec to walk to car
			Citizen.Wait(10000)
		
			-- helper drives to set coords
			TaskVehicleDriveToCoord(chopshop2,vehicle, 2354.35, 3155.85, 48.25, 7.5, 500, -1 ,63, 1.0, 2)

			--gets 15 sec to drive car to location
			Citizen.Wait(15000)
		
			-- helper gets out of vehicle
			TaskLeaveVehicle(chopshop2, vehicle, 64)
			Citizen.Wait(2000)


			checkClassOfCar(class)
	
		else
			Citizen.Wait(0)
		end
	end
end

Citizen.CreateThread(function()
   local DMVmarkerPos = vector3(1160.948, -3199.143, -39.00799)
   local ScrapmarkerPos = vector3(2340.852, 3126.44, 48.21)
	
	-- spawn main scrap guy
	RequestModel(0x6C9B2849)
	chopshop1 = CreatePed(30, 0x6C9B2849, 2340.852, 3126.44, 48.2, 1.31, true, false)
	SetPedFleeAttributes(chopshop1, 0, 0)
        SetPedDropsWeaponsWhenDead(chopshop1, false)
        SetPedDiesWhenInjured(chopshop1, false)
        SetEntityInvincible(chopshop1 , true)
        SetBlockingOfNonTemporaryEvents(chopshop1, true)
	Citizen.Wait(850)
	FreezeEntityPosition(chopshop1, true)
   

   while true do
	Citizen.Wait(1)
	local ped = PlayerPedId()
	local playerCoords = GetEntityCoords(ped)
	local DMVdistance = #(playerCoords - DMVmarkerPos)
	local Scrapdistance = #(playerCoords - ScrapmarkerPos)
	
		if DMVdistance < 1.5 then
			isInMarker = true
			fixDMVFiles()
		else 
			isInMarker = false
		end

		if Scrapdistance < 2.5 then
			isInMarker = true

			chopcar()
		else 
			isInMarker = false
		end
	end
end)
