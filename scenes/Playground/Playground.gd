extends Node2D

const building_scene: PackedScene = preload('res://entities/building/building.tscn')

onready var player = $World/Player
onready var buildings_holder = $BuildingsHolder

onready var building_ghost = $BuildingGhost

# var et non onready car le GUI est (pour l'instant un child de la camera, child de player, non certain au départ
var craft_panel

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
  new_building.connect('player_entered_owned_building', craft_panel, "_on_player_entered_owned_building")
  new_building.connect('player_exited_owned_building', craft_panel, "_on_player_exited_owned_building")
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
  var new_armor = Data.crafts[0].product.new()
  player.gear['body'] = new_armor
  player.gain_xp("def", 4)
  GameManager.player_actor = player
  # a faire après que le player soit instancié
  craft_panel = $World/Player/Camera2D/CraftPanel
  
