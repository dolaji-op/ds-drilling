PLATFORM = {}
PLATFORM.__index = PLATFORM
local playerPed = PlayerPedId()
local playerCoords = GetEntityCoords(playerPed)
local pressed = false
Peddata = {}

Citizen.CreateThread(function()
    while true do
        Wait(100)
        playerPed = PlayerPedId()
        playerCoords = GetEntityCoords(playerPed)
    end
end)

function PLATFORM:Init(index, data)
    local o = data
    setmetatable(o, PLATFORM)
    o.coords = vector3(data.Position.X, data.Position.Y, data.Position.Z)
    o.index = index
    o:MainThread()
    o:NUIHandler()

    if Config.UseEyeTarget then
        CreateBoxTarget(index,o.coords,100.0)
    end

    if Config.UseBlips then
        o:CreateBlip()
    end
    return o
end


RegisterNetEvent('ds-drilling:startDrilling', function()
    pressed = true
end)


function PLATFORM:CreateBlip()
    if Config.UseBlips then
        self.blip = AddBlipForCoord(self.coords.x, self.coords.y, self.coords.z)
        SetBlipSprite(self.blip, Config.Blip.Sprite)
        SetBlipColour(self.blip, Config.Blip.Color)
        SetBlipAsShortRange(self.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Blip.Label)
        EndTextCommandSetBlipName(self.blip)
        SetBlipScale(self.blip, Config.Blip.Scale)
    end
end

function PLATFORM:NUIHandler()
    RegisterNUICallback("Close", function()
        if self.active then
            self:Close()
        end
        CloseNui()
    end)
    RegisterNUICallback('Drill', function(data, cb)
        if self.active then
            TriggerServerEvent('ds-drilling:server:Drill', self.index, data.product)
        end

    end)
end

function PLATFORM:MainThread()
    Citizen.CreateThread(function()
        while true do
            Wait(0)
            local distance = #(self.coords - playerCoords)
            if distance < 20.0 and not self.active and CheckJob() then
                if distance <= 5.0 and not IsPedInAnyVehicle(playerPed, false) then
                    if Config.UseDrawText then
                        DrawText3Ds(self.coords, Config.Language['draw_text'])
                        if IsControlJustReleased(0, 38) then
                            self:CreateCam()
                            self:Open()
                        end
                    end
                    if Config.UseEyeTarget then
                        if pressed then
                            self:CreateCam()
                            self:Open()
                        end
                        pressed = false
                    end
                end
            else
                Wait(5000)
            end
        end
    end)

end


function PLATFORM:CreateCam()
    self:DestroyCam()
    local obj = GetClosestObjectOfType(self.coords.x, self.coords.y, self.coords.z, 5.0, GetHashKey(self.Name), false, 1, 1)
    local objCoords = GetEntityCoords(obj)
    local coords = GetOffsetFromEntityInWorldCoords(obj, 10.0, -10.0, 0.0)
    local pointCoords = GetOffsetFromEntityInWorldCoords(obj, 0.0, -7.0, 0.0)
    self.cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x, coords.y, coords.z + 8.0, 0.0, 0.0, 0.0, 65.00, false, false)
    SetCamActive(self.cam, true)
    PointCamAtCoord(self.cam, pointCoords.x, pointCoords.y, pointCoords.z + 7.0)
    RenderScriptCams(true, true, 2000, true, true)
    Wait(2000)
end

function PLATFORM:DestroyCam()
    SetCamActive(self.cam,  false)
    DestroyAllCams(true)
    RenderScriptCams(false,  true,  2000,  true,  true)
end


function PLATFORM:Close()
    SendNUIMessage({
        event = "setShow",
        data = false
    })
    SetNuiFocus(false, false)
    self.active = false
    self:DestroyCam()
    TriggerServerEvent('ds-drilling:server:leavePlatform', self.index)
end

function PLATFORM:Sync(data)
    for k, v in pairs(data) do
        self[k] = v
    end
    SendNUIMessage({
        event = "setData",
        data = self
    })
end

MAIN = {}
function MAIN:Init()
    local o = {}
    setmetatable(o, {__index = MAIN})
    o.Platforms = {}
    o:PlatformInit()
    o:EventHander()
    return o
end

function MAIN:PlatformInit()
    for k, v in ipairs(Config.Platforms) do
        self.Platforms[k] = PLATFORM:Init(k, v)

    end
end

function MAIN:EventHander()
    RegisterNetEvent('ds-drilling:client:syncPlatform', function(platformData)
        self.Platforms[platformData.index]:Sync(platformData)
    end)
end

Citizen.CreateThread(function()
    MAIN:Init()
end)

