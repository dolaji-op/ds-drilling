MAIN = {}

function MAIN:Init()
    local o = {}
    setmetatable(o, {__index = MAIN})
    o.Platforms = {}
    o:InitPlatform()
    o:EventHander()
    o:CallbackHander()
    return o
end

function MAIN:InitPlatform()
    for k, v in ipairs(Config.Platforms) do 
        self.Platforms[k] = PLATFORM:Init(k, v, nil)
    end
end

function MAIN:EventHander()
    

    RegisterNetEvent('ds-drilling:server:Drill', function(index, product)
        if self.Platforms[index]:Drill() then
            local item = Config.Reward[product].item
            AddItem(source, item, Config.Reward[product].qty)
        else
            Notify(source, Config.Language['no_oil'], "error")
        end
    end)

    RegisterNetEvent('ds-drilling:server:leavePlatform', function(index)
        self.Platforms[index]:Leave(source)
    end)
end

RegisterServerEvent("ds-drilling:server:sellstuff")
AddEventHandler("ds-drilling:server:sellstuff", function(item, qty)
    local src = source
    if RemoveItem(source,item, qty) then
        AddMoney(src, Config.SellingPrices[item].price*qty)
    end
end)


Citizen.CreateThread(function()
    MAIN:Init()
end)