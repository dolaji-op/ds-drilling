QBCore = exports['qb-core']:GetCoreObject()

AddItem = function(src, item, qty)
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(item, qty)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
end

RemoveItem = function(src, item, qty)
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(item, qty) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove")
        return true
    end
    return false
end

AddMoney = function(src, amount)
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', amount)
end


Notify = function(src, msg, type)
    TriggerClientEvent('QBCore:Notify', src, msg, type)
end

function MAIN:CallbackHander()
    QBCore.Functions.CreateCallback('ds-drilling:callback:getPlatformData', function(source, cb, index)
        self.Platforms[index]:Join(source)
        cb(self.Platforms[index])
    end)
end

