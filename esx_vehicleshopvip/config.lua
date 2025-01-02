Config = {}

-- Shop Location Configuration
Config.Zones = {
    ShopEntering = {
        Pos   = vector3(-36.15, -1110.20, 25.40),
        Size  = {x = 1.5, y = 1.5, z = 1.0},
        Type  = 1
    },

    ShopInside = {
        Pos     = vector3(-30.791206, -1100.940674, 34.048340),
        Size    = {x = 1.5, y = 1.5, z = 1.0},
        Heading = 253.9435,
        Type    = -1
    },

    ShopOutside = {
        Pos     = vector3(-59.050545, -1073.261597, 27.207275),
        Size    = {x = 1.5, y = 1.5, z = 1.0},
        Heading = 2.6208,
        Type    = -1
    }
}

-- VIP Coin Display Settings
Config.VipCoinDisplay = {
    Enabled = true,
    Position = {x = 0.9, y = 0.1}, -- Example position on the screen
    Color = {r = 255, g = 215, b = 0} -- Gold color for VIP coins
}

-- Blip Configuration
Config.Blip = {
    show = true,
    Sprite = 326,
    Display = 4,
    Scale = 0.8
}

-- Additional Configurations
Config.EnableLicenseCheck = false -- Whether to check for a license before allowing purchases
Config.Locale = 'en' -- Default locale for translations
