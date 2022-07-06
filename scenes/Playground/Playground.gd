extends Node2D

const building_scene: PackedScene = preload('res://entities/building/building.tscn')

onready var player = $World/Player
onready var building_ghost = $BuildingGhost

onready var buildings_holder = $BuildingsHolder

var is_placing_building = false
var type_to_build = null

func build_mode_on() -> void:
  is_placing_building = true
  type_to_build = Data.buildings[0]
  building_ghost.global_position = get_global_mouse_position()
  building_ghost.show()

func build_mode_off() -> void:
  is_placing_building = false
  building_ghost.hide()

func place_building() -> void:
  var new_building = building_scene.instance()
  buildings_holder.add_child(new_building)
  new_building.init(player, type_to_build, get_global_mouse_position())
  build_mode_off()

func _unhandled_input(event):
  if event is InputEventMouseButton:
    if event.button_index == BUTTON_LEFT and event.pressed:
      # en train de construire
      if is_placing_building:
        # TODO verif de présence d'obstacles
        place_building()
      else :
        var pos = get_global_mouse_position()
        player.move_to(pos)
    if event.button_index == BUTTON_RIGHT and event.pressed:
      build_mode_off()
      
  if event is InputEventMouseMotion and is_placing_building:
    building_ghost.global_position = get_global_mouse_position()

func _ready():
  var new_armor = LeatherJacket.new()
  player.gear['body'] = new_armor
  player.gain_xp("def", 4)
  GameManager.player_actor = player
  
