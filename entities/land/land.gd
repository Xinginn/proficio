extends Node2D

var land_type: int

func _initialize(land_code: String):
  print(land_code)
  var texture = null
  var path = "res://assets/lands/"
  land_type = int(land_code[0])
  var orientation =int(land_code[1])
  match land_type:
    0:
      path += "center"
    1:
      path += "crown"
    2:
      path += "plain"
    3:
      path += "forest"
    _:
      print('unexpected number while parsing land_type %d' % land_type)
      
  if orientation == 0:
    path += ".png"
  elif orientation % 2 == 0:
    path += "_border.png"
  else:
    path += "_corner.png"
  
  print(path)
  $Sprite.texture = load(path)

  # calcul rotation selon orientation
  if orientation > 0:
    $Sprite.rotation_degrees = ( (int((orientation +1) /2) * 90) % 360 ) - 90
