extends TechData

class_name SelfCenteredData

var area_multiplier: float

func _init(_id: int, _tech_name: String, _type: String, _skill: String, _xp_gain: int, _cost: Dictionary, _cooldown: float, _area_multiplier: float):
  id = _id
  _name = _tech_name
  type = _type
  skill = _skill
  xp_gain = _xp_gain
  for key in _cost.keys():
    cost[key] = _cost[key]
  cooldown = _cooldown
  area_multiplier = _area_multiplier
