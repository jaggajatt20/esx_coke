Config = {}

Config.Locale = 'es'

Config.DrawDistance = 50
Config.MarkerColor = { r = 255, g = 0, b = 255 }
Config.MarkerScale = { x = 4.0, y = 4.0, z = 0.5 }
Config.MarkerType = 1

Config.Delays = {
    CokeRecolecting = 1000 * 5,
    CokeProcessing = 1000 * 10
}

Config.DrugDealerItems = {
    coke_leaf = 1000
}

Config.GiveBlack = true

Config.CircleZones = {
	CokeField = {coords = vector3(67.85, 3758.45, 39.75), name = _U('blip_cokefield'), color = 4, sprite = 497, radius = 100.0},
    CokeProcessing = {coords = vector3(1392.55, 3606.00, 38.95), name = _U('blip_cokeprocessing'), color = 4, sprite = 497, radius = 100.0},
    DrugDealer = {coords = vector3(-2173.50, 4289.70, 49.05), name = _U('blip_drugdealer'), color = 4, sprite = 497, radius = 100.0}
}