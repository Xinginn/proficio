extends TechData

class_name StrikeData

var strike_range: int

func _init(_id: int, _tech_name: String, _type: String, _skill: String, _xp_gain: int, _cost: Dictionary, _cooldown: float, _range: int):
  id = _id
  _name = _tech_name
  type = _type
  skill = _skill
  xp_gain = _xp_gain
  for key in _cost.keys():
    cost[key] = _cost[key]
  cooldown = _cooldown
  strike_range = _range
