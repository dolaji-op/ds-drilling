
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddItem = function(src, item, qty)
    local Player = ESX.GetPlayerFromId(src)
    Player.addInventoryItem(item, qty)
end

RemoveItem = function(src, item, qty)
    local Player = ESX.GetPlayerFromId(src)
    local ItemData = Player.getInventoryItem(item).count
    if ItemData >= qty then
        Player.removeInventoryItem(item, qty)
        return true
    end
    return false
end

AddMoney = function(src, amount)
    local Player = ESX.GetPlayerFromId(src)
    Player.addMoney(amount)
end


Notify = function(src, msg, type)
    TriggerClientEvent('esx:showNotification', src, msg)
end

function MAIN:CallbackHander()
    ESX.RegisterServerCallback('ds-drilling:callback:getPlatformData', function(source, cb, index)
        self.Platforms[index]:Join(source)
        cb(self.Platforms[index])
    end)
end

