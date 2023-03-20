QBCore = exports['qb-core']:GetCoreObject()
PlayerJob = nil

--------------- Events -----------------------

RegisterNetEvent('QBCore:Client:OnJobUpdate') ---- qbcore job update event
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded') ---- qbcore player loaded event
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
end)


RegisterNetEvent('ds-drilling:sellsomething')
AddEventHandler('ds-drilling:sellsomething', function()
    local newdx = {}
    for k,v in pairs(Config.SellingPrices) do
        table.insert(newdx, { value = k, text = v.label })
    end
    local dialog = exports['qb-input']:ShowInput({
        header = Config.Language['sell_mining'],
        submitText = "Sell",
        inputs = {
            {
                text = Config.Language['select_item'],
                name = "item",
                type = "select",
                options = newdx
            },

            {
                text = "Amount",
                name = "amount",
                type = "number",
                isRequired = true
            },
        },
    })
    if dialog ~= nil then
        if tonumber(dialog['amount']) > 0 then
            TriggerServerEvent('ds-drilling:server:sellstuff', dialog['item'], tonumber(dialog['amount']))
        end
    end
end)

--------------- Events End -----------------------



--------------- Functions -----------------------



function CloseNui()
    --- ui close event --------------------------------
end

function PLATFORM:Open()
    if not self.active then
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            return
        end
        QBCore.Functions.TriggerCallback('ds-drilling:callback:getPlatformData',function(data)
            for k, v in pairs(data) do
                self[k] = v
            end
            SendNUIMessage({
                event = "setData",
                data = self
            })
            SendNUIMessage({
                event = "setShow",
                data = true
            })
            SetNuiFocus(true, true)
            self.active = true
        end, self.index)
    end
end


CheckJob = function()  ---- job check function.
	local check = false
	if Config.RequireJob then
		if PlayerJob ~= nil and PlayerJob.name == Config.JobName then
			check = true
		end
	else
		check = true
	end
	return check
end

DrawText3Ds = function(coords, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

--------------- Functions END-----------------------




----------- Qb target exports ------------------

CreateBoxTarget = function(k, coordinates, heading) --- Eye Target Function chnage if you are using diffrent script
    exports['qb-target']:AddBoxZone("oil"..k, coordinates, 5.0, 5.0, {
        name="oil"..k,
        heading= heading,
        debugPoly=false,
        minZ= coordinates.z-0.9,
        maxZ= coordinates.z+5,
        }, {
            options = {
                {
                    type = "client",
                    event = 'ds-drilling:startDrilling',
                    icon = "fas fa-eye",
                    label = Config.Language['eye_target'],
                },
            },
            distance = 3.5
    })
end




----------- Qb target exports end------------------



--- Seller PED

Sellerped = nil
local pedc = vector3(Config.Seller.coords.x,Config.Seller.coords.y,Config.Seller.coords.z)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local pedcoo = GetEntityCoords(PlayerPedId())
        if #(pedcoo - pedc) < 100.0 then
            if Sellerped ~= nil then
                if not DoesEntityExist(Sellerped) then
                    RequestModel(GetHashKey(Config.Seller.model))
                    while not HasModelLoaded(GetHashKey(Config.Seller.model)) do
                        RequestModel(GetHashKey(Config.Seller.model))
                        Wait(100)
                    end
                    Sellerped = CreatePed(4, GetHashKey(Config.Seller.model), Config.Seller.coords, false, false)
                    createdPed = Sellerped
                    ClearPedTasks(createdPed)
                    ClearPedSecondaryTask(createdPed)
                    TaskSetBlockingOfNonTemporaryEvents(createdPed, true)
                    SetPedFleeAttributes(createdPed, 0, 0)
                    SetPedCombatAttributes(createdPed, 17, 1)
                    SetPedSeeingRange(createdPed, 0.0)
                    SetPedHearingRange(createdPed, 0.0)
                    SetPedAlertness(createdPed, 0)
                    SetPedKeepTask(createdPed, true)
                    Wait(1000)
                    FreezeEntityPosition(createdPed, true)
                    SetEntityInvincible(createdPed, true)
                    if Config.UseEyeTarget then
                        exports['qb-target']:AddBoxZone("seller", pedc, 0.70, 0.70, {
                            name= "seller",
                            heading= Config.Seller.coords.h,
                            debugPoly= false,
                            minZ=v.pedc.z-0.9,
                            maxZ=v.pedc.z+0.9,
                            }, {
                                options = {
                                    {
                                        type = "client",
                                        event = 'ds-drilling:sellsomething',
                                        icon = "fas fa-eye",
                                        label = '💲 '.."Sell Items",
                                    },
                                },
                            distance = 2.5
                        })
                    end
                else
                    local ccd = GetEntityCoords(Sellerped)
                    if #(ccd - pedc) > 5 then
                        DeleteEntity(Sellerped)
                        RequestModel(GetHashKey(Config.Seller.model))
                        while not HasModelLoaded(GetHashKey(Config.Seller.model)) do
                            RequestModel(GetHashKey(Config.Seller.model))
                            Wait(100)
                        end
                        Sellerped = CreatePed(4, GetHashKey(Config.Seller.model), Config.Seller.coords, false, false)
                        createdPed = Sellerped
                        ClearPedTasks(createdPed)
                        ClearPedSecondaryTask(createdPed)
                        TaskSetBlockingOfNonTemporaryEvents(createdPed, true)
                        SetPedFleeAttributes(createdPed, 0, 0)
                        SetPedCombatAttributes(createdPed, 17, 1)
                        SetPedSeeingRange(createdPed, 0.0)
                        SetPedHearingRange(createdPed, 0.0)
                        SetPedAlertness(createdPed, 0)
                        SetPedKeepTask(createdPed, true)
                        Wait(1000)
                        FreezeEntityPosition(createdPed, true)
                        SetEntityInvincible(createdPed, true)
                        if Config.UseEyeTarget then
                            exports['qb-target']:AddBoxZone("seller", pedc, 0.70, 0.70, {
                                name= "seller",
                                heading= Config.Seller.coords.h,
                                debugPoly= false,
                                minZ=v.pedc.z-0.9,
                                maxZ=v.pedc.z+0.9,
                                }, {
                                    options = {
                                        {
                                            type = "client",
                                            event = 'ds-drilling:sellsomething',
                                            icon = "fas fa-eye",
                                            label = '💲 '.."Sell Items",
                                        },
                                    },
                                distance = 2.5
                            })
                        end
                    end
                end
            else
                RequestModel(GetHashKey(Config.Seller.model))
                while not HasModelLoaded(GetHashKey(Config.Seller.model)) do
                    RequestModel(GetHashKey(Config.Seller.model))
                    Wait(100)
                end
                Sellerped = CreatePed(4, GetHashKey(Config.Seller.model), Config.Seller.coords, false, false)
                createdPed = Sellerped
                ClearPedTasks(createdPed)
                ClearPedSecondaryTask(createdPed)
                TaskSetBlockingOfNonTemporaryEvents(createdPed, true)
                SetPedFleeAttributes(createdPed, 0, 0)
                SetPedCombatAttributes(createdPed, 17, 1)
                SetPedSeeingRange(createdPed, 0.0)
                SetPedHearingRange(createdPed, 0.0)
                SetPedAlertness(createdPed, 0)
                SetPedKeepTask(createdPed, true)
                Wait(1000)
                FreezeEntityPosition(createdPed, true)
                SetEntityInvincible(createdPed, true)
                if Config.UseEyeTarget then
                    exports['qb-target']:AddBoxZone("seller", pedc, 0.70, 0.70, {
                        name= "seller",
                        heading= Config.Seller.coords.h,
                        debugPoly= false,
                        minZ= pedc.z-0.9,
                        maxZ= pedc.z+0.9,
                        }, {
                            options = {
                                {
                                    type = "client",
                                    event = 'ds-drilling:sellsomething',
                                    icon = "fas fa-eye",
                                    label = '💲 '.."Sell Items",
                                },
                            },
                        distance = 2.5
                    })
                end
            end
        end
    end
end)

if Config.UseDrawText then
    Citizen.CreateThread(function()
		while true do
			Citizen.Wait(4)
			local pedpos = GetEntityCoords(PlayerPedId())
			if #(pedc - pedpos) < 5.0 then
                DrawMarker(27, pedc.x,pedc.y,pedc.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 255, 0, 0, 0, 1, 0, 0, 0)
                if #(pedc - pedpos) < 2.0 then
                    DrawText3Ds(pedc, '[E] Sell Items')
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('ds-drilling:sellsomething')
                    end
                end
            end
		end
	end)
end