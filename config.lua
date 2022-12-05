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
	["lifeinvaderbackend"] = {
		position = { x = -1049.73, y = -242.09, z = 44.00 },
		reward = math.random(50, 2000),
		nameOfStore = "LifeInvader - Backend",
		secondsRemaining = 30, -- seconds
		lastRobbed = 0
	},
	["lifeinvaderdevops"] = {
		position = { x = -1053.95, y = -230.19, z = 44.00 },
		reward = math.random(50, 2000),
		nameOfStore = "LifeInvader - DevOps",
		secondsRemaining = 30, -- seconds
		lastRobbed = 0
	},
	["lifeinvaderfrontend"] = {
		position = { x = -1057.78, y = -245.69, z = 44.00 },
		reward = math.random(50, 2000),
		nameOfStore = "LifeInvader - Frontend",
		secondsRemaining = 30, -- seconds
		lastRobbed = 0
	},
	["realestatefrontend"] = {
		position = { x = -145.98, y = -638.10, z = 168.82 },
		reward = math.random(50, 2000),
		nameOfStore = "Real Estate Agency - Frontend",
		secondsRemaining = 30, -- seconds
		lastRobbed = 0
	},
	["realestatebackend"] = {
		position = { x = -145.98, y = -635.12, z = 168.82 },
		reward = math.random(50, 2000),
		nameOfStore = "Real Estate Agency - Backend",
		secondsRemaining = 30, -- seconds
		lastRobbed = 0
	},
}
