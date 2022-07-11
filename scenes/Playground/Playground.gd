extends Node2D

const building_scene: PackedScene = preload('res://entities/building/building.tscn')

onready var player = $World/Player
onready var buildings_holder = $World/BuildingsHolder
onready var resource_spots_holder = $World/ResourceSpotsHolder
onready var inventory_panel = $World/Player/Camera2D/InventoryPanel

onready var building_ghost = $BuildingGhost

# var est non onready car le GUI est (pour l'instant un child de la camera, child de player, non certain au départ
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
  new_building.connect('craft_queue_changed', craft_panel, "_on_craft_queue_changed")
  new_building.connect('craft_progress_changed', craft_panel, "_on_craft_progress_changed")
  craft_panel.connect('recipe_requested', new_building, '_on_recipe_requested')
  craft_panel.connect('cancel_requested', new_building, '_on_cancel_requested')
  build_mode_off()

func _unhandled_input(event):
  if event is InputEventMouseButton:
    if event.button_index == BUTTON_LEFT and event.pressed:
      # en train de construire
      if is_placing_building:
        # TODO verif de présence d'obstacles
        if GameManager.player_actor.has_resources(type_to_build.resources):
          for key in type_to_build.resources.keys():
            GameManager.player_actor.remove_resource(key, type_to_build.resources[key])
          place_building()
      else :
        var pos = get_global_mouse_position()
        player.move_to(pos)
    if event.button_index == BUTTON_RIGHT and event.pressed:
      build_mode_off()
      
func _process(delta):
  if is_placing_building:
    building_ghost.global_position = get_global_mouse_position()

func _ready():
  GameManager.player_actor = player
  # dans ready car a faire après que le player soit instancié
  craft_panel = $World/Player/Camera2D/CraftPanel
  
  player.connect('gold_changed', inventory_panel, "_on_gold_changed")
  player.connect('resources_changed', inventory_panel, "_on_resources_changed")
  player.connect('inventory_changed', inventory_panel, "_on_inventory_changed")
  
  # zone de seed pour test
  var new_armor = Data.crafts[0].product.new()
  player.inventory.gear['body'] = new_armor
  player.emit_signal('inventory_changed', player.inventory)
  player.add_resource("wood", 4)
  player.add_resource("stone", 3)
  player.add_resource("leather", 8)
  print(player.inventory.resources)
  player.gold += 4
