Config = {}

Config.Platforms = json.decode(LoadResourceFile(GetCurrentResourceName(), "Platforms.json")) -- don't touch this
Config.DefaultQuantity = 1000 -- default quantity for all platforms
Config.UseEyeTarget = false -- enable or disable eye target for all platforms
Config.UseDrawText =  true -- enable or disable draw text for all platforms

Config.RequireJob = false --- enable this if you want to use job only.
Config.JobName = "mining" --- job name Note: make sure you add job in your server accordingly your framework.

Config.Reward = { --- reward after drilling complete
    ['kerosene'] = {
        item = "kerosene",
        qty = math.random(1,2),
    },
    ['gasoline'] = {
        item = "gasoline",
        qty = math.random(1,2),
    },
}

Config.UseBlips = true -- enable or disable blips for all platforms
Config.Blip = {
    Sprite = 648,
    Scale = 0.5,
    Color = 2,
    Label = 'Mining'
}

Config.UseSelling = true -- enable or disable selling
Config.Seller = {
    coords = vector4(1521.5197753906, -2114.2438964844, 76.804397583008, 275.16198730469),
    model = "g_m_m_chiboss_01"
}
Config.SellingPrices = {
    ["kerosene"] = {label = "Kerosene", price = math.random(100,150)},
    ["gasoline"] = {label = "Gasoline", price = math.random(100,150)},
}


Config.Language = {
    ['no_oil'] = "This drill was exhausted!",
    ['draw_text'] = "[E] - Start Drilling",
    ['eye_target'] = "Start Drilling",
    ['sell_mining'] = "Sell your Petroleums",
    ['select_item'] = "Select Item",
}



