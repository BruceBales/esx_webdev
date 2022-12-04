Config = {}
Config.Locale = 'en'

Config.Marker = {
	r = 250, g = 0, b = 0, a = 100,  -- red color
	x = 1.0, y = 1.0, z = 1.5,       -- tiny, cylinder formed circle
	DrawDistance = 15.0, Type = 1    -- default circle type, low draw distance due to indoors area
}

Config.PoliceNumberRequired = 0
Config.TimerBeforeNewRob    = 30 -- The cooldown timer on a store after robbery was completed / canceled, in seconds

Config.MaxDistance    = 20   -- max distance from the robbary, going any longer away from it will to cancel the robbary
Config.GiveBlackMoney = false -- give black money? If disabled it will give cash instead

Stores = {
	["lifeinvader"] = {
		position = { x = -1049.73, y = -242.09, z = 44.00 },
		reward = math.random(50, 2000),
		nameOfStore = "LifeInvader",
		secondsRemaining = 30, -- seconds
		lastRobbed = 0
	},
}
