extends Node2D

const building_scene: PackedScene = preload('res://entities/building/building.tscn')
const building_button_scene: PackedScene = preload('res://entities/building_button/building_button.tscn')

const GREEN_HUE = Color('a200ff00')
const RED_HUE = Color('99ff0000')

onready var player = $World/Player
onready var buildings_holder = $World/BuildingsHolder
onready var inventory_panel = $World/Player/Camera2D/InventoryPanel
onready var status_panel = $World/Player/Camera2D/StatusPanel
onready var gauges_manager = $World/Player/Camera2D/GaugesManager
onready var building_buttons_container = $World/Player/Camera2D/StartBuildButton/BuildingButtonsContainer

onready var building_ghost = $BuildingGhost
onready var building_ghost_occupied_space = $BuildingGhost/OccupiedSpaceArea
onready var building_ghost_occupied_collision = $BuildingGhost/OccupiedSpaceArea/CollisionShape2D

# var est non onready car le GUI est (pour l'instant un child de la camera, child de player, non certain au départ
var craft_panel

var is_placing_building = false
var is_selecting_building = false
var type_to_build = null
var is_building_ghost_overlapped = false
var last_building = null

func _on_start_build_button_pressed():
  for child in building_buttons_container.get_children():
    child.queue_free()
  if is_selecting_building:
    build_mode_off()
  else:
    # instanciation de tous les boutons
    for data in Data.buildings:
      var new_button = building_button_scene.instance()
      building_buttons_container.add_child(new_button)
      new_button._initialize(data)
      new_button.connect("building_button_pressed", self, "_on_building_button_pressed")
      new_button.connect("building_button_pright_pressed", self, "build_mode_off")

func _on_building_button_pressed(data) -> void:
  is_placing_building = true
  type_to_build = data
  building_ghost.global_position = get_global_mouse_position()
  var texture = load('res://assets/buildings/%s.png' % data._name)
  building_ghost.texture = texture
  building_ghost_occupied_collision.shape.extents = texture.get_size() / 2.0
  building_ghost.show()

func build_mode_off() -> void:
  is_placing_building = false
  building_ghost.hide()
  for child in building_buttons_container.get_children():
    child.queue_free()

func place_building() -> void:
  var new_building = building_scene.instance()
  buildings_holder.add_child(new_building)

  new_building._initialize(player, type_to_build, get_global_mouse_position())
  new_building.connect('player_entered_building', self, "_on_player_entered_building")
  new_building.connect('player_entered_owned_building', craft_panel, "_on_player_entered_owned_building")
  new_building.connect('player_exited_owned_building', craft_panel, "_on_player_exited_owned_building")
  # deconnexion des signaux entre le craft panel et le precedent building
  build_mode_off()


func _on_player_entered_building(building) -> void:
  if !!last_building:
    last_building.disconnect('craft_queue_changed', craft_panel, "_on_craft_queue_changed")
    last_building.disconnect('craft_progress_changed', craft_panel, "_on_craft_progress_changed")
    craft_panel.disconnect('recipe_requested', last_building, '_on_recipe_requested')
    craft_panel.disconnect('cancel_requested', last_building, '_on_cancel_requested')
  building.connect('craft_queue_changed', craft_panel, "_on_craft_queue_changed")
  building.connect('craft_progress_changed', craft_panel, "_on_craft_progress_changed")
  craft_panel.connect('recipe_requested', building, '_on_recipe_requested')
  craft_panel.connect('cancel_requested', building, '_on_cancel_requested')
  last_building = building
  

func _unhandled_input(event):
  if event is InputEventMouseButton:
    if event.button_index == BUTTON_LEFT and event.pressed:
      # en train de construire
      if is_placing_building:
        if is_building_ghost_overlapped:
          return
        if GameManager.player_actor.has_resources(type_to_build.resources):
          for key in type_to_build.resources.keys():
            GameManager.player_actor.remove_resource(key, type_to_build.resources[key])
          place_building()
      else :
        var pos = get_global_mouse_position()
        player.move_to(pos)
    if event.button_index == BUTTON_RIGHT and event.pressed:
      build_mode_off()
      
func _physics_process(_delta):
  if !is_placing_building:
    pass
  else:
    building_ghost.global_position = get_global_mouse_position()
    if building_ghost_occupied_space.get_overlapping_areas():
      building_ghost.modulate = RED_HUE
      is_building_ghost_overlapped = true
    else:
      building_ghost.modulate = GREEN_HUE
      is_building_ghost_overlapped = false
      
     
func _ready():
  GameManager.player_actor = player
  print(GameManager.player_actor)
  # dans ready car a faire après que le player soit instancié
  craft_panel = $World/Player/Camera2D/CraftPanel
  status_panel.initialize()
  
  player.connect('gold_changed', inventory_panel, "_on_gold_changed")
  player.connect('weight_changed', inventory_panel, "_on_weight_changed")
  player.connect('resources_changed', inventory_panel, "_on_resources_changed")
  player.connect('inventory_changed', inventory_panel, "_on_inventory_changed")
  player.connect('health_changed', gauges_manager, '_on_player_health_changed')
  player.connect('stamina_changed', gauges_manager, '_on_player_stamina_changed')
  player.connect('mana_changed', gauges_manager, '_on_player_mana_changed')
  player.connect('experience_changed', status_panel, '_on_player_experience_changed')
  
  # zone de seed pour test
  var new_armor = Data.crafts[0].product.new()
  player.inventory.gear['body'] = new_armor
  player.emit_signal('inventory_changed', player.inventory)
  player.add_resource("wood", 4)
  player.add_resource("stone", 3)
  player.add_resource("leather", 8)
  player.gold += 4
