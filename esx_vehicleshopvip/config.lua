Config                            = {}
Config.DrawDistance               = 15
Config.MarkerColor                = {r = 255, g = 215, b = 0} -- Gold color for VIP
Config.EnableVIPManagement        = true -- enables the VIP vehicle shop management
Config.Locale                     = GetConvar('esx:locale', 'en')

Config.VIPCoinSettings = {
    Enabled = true,
    CoinName = "VIP Coin",
    InitialCoins = 10 -- Initial coins given to new VIP players
}

Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true

Config.Blip = {
    show = true,
    Sprite = 523, -- Different sprite for VIP shop
    Display = 4,
    Scale = 1.0
}

Config.Zones = {
    ShopEntering = {
        Pos   = vector3(-50.0, -1100.0, 26.0),
        Size  = {x = 1.5, y = 1.5, z = 1.0},
        Type  = 1
    },

    ShopInside = {
        Pos     = vector3(-45.0, -1095.0, 26.0),
        Size    = {x = 1.5, y = 1.5, z = 1.0},
        Heading = 250.0,
        Type    = -1
    },

    ShopOutside = {
        Pos     = vector3(-60.0, -1080.0, 26.0),
        Size    = {x = 1.5, y = 1.5, z = 1.0},
        Heading = 0.0,
        Type    = -1
    }
}

Config.VIPCategories = {
    {name = 'luxury', label = 'Luxury'},
    {name = 'sports', label = 'Sports'},
    {name = 'super', label = 'Super'}
}
