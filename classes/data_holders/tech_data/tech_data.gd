extends Node

class_name TechData

var id: int
var _name: String
var type: String # strike, projectile, self-centered ou spot
var skill: String
var xp_gain: int
var cost: Dictionary = {"health": 0, "stamina": 0, "mana": 0}
var cooldown
