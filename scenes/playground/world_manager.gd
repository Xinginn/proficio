extends Node2D

const land_scene: PackedScene = preload('res://entities/land/land.tscn')

const LAND_SIZE = 512

onready var lands_holder = $LandsHolder

var map = [
  ["20"]#, "12", "00", "16", "20", "32", "30"],
#  ["20", "11", "18", "17", "20", "31", "38"],
#  ["20", "20", "20", "20", "20", "20", "20"],
]

func generate_blank_map(size):
  map = []
  for _y in range(size):
    var line = []
    for _x in range(size):
      line.append("20")
    map.append(line)

func _ready():
  generate_blank_map(GameManager.world_size)
  
  # generation du terrain
  for i in range(map.size()):
    for j in range(map[i].size()):
      var new_land = land_scene.instance()
      lands_holder.add_child(new_land)
      new_land._initialize(map[i][j])
      new_land.position = Vector2(LAND_SIZE * j, LAND_SIZE * i)
