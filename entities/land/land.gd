extends Node2D

onready var resources_holder: Node2D = $ResourcesHolder

var land_data: LandData
var resources_lottery: Array = []


func _initialize(land_code: String):
  var texture = null
  var path = "res://assets/lands/"
  land_data = Data.lands[int(land_code[0])]
  var orientation =int(land_code[1])
  path += land_data.land_name
  if orientation == 0:
    path += ".png"
  elif orientation % 2 == 0:
    path += "_border.png"
  else:
    path += "_corner.png"
  
  $Sprite.texture = load(path)

  # calcul rotation selon orientation
  if orientation > 0:
    $Sprite.rotation_degrees = ( (int((orientation +1) /2) * 90) % 360 ) - 90
