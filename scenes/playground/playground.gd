extends Node2D

const building_scene: PackedScene = preload('res://entities/building/building.tscn')
const castle_scene: PackedScene = preload('res://entities/building/castle/castle.tscn')
const building_button_scene: PackedScene = preload('res://entities/building_button/building_button.tscn')
const npc_scene = preload('res://entities/actor/npc.tscn')

const GREEN_HUE = Color('a200ff00')
const RED_HUE = Color('99ff0000')

onready var world = $World
onready var buildings_holder = $World/BuildingsHolder
onready var camera = $Camera
onready var inventory_panel = $Camera/InventoryPanel
onready var status_panel = $Camera/StatusPanel
onready var building_window = $Camera/BuildingWindow
onready var craft_panel = $Camera/BuildingWindow/CraftTab/CraftPanel
onready var storage_panel = $Camera/BuildingWindow/StorageTab/StoragePanel
onready var refine_panel = $Camera/BuildingWindow/RefineTab/RefinePanel
onready var contribution_panel = $Camera/BuildingWindow/ContributionTab/ContributionPanel 
onready var resurrection_panel = $Camera/BuildingWindow/ResurrectionTab/ResurrectionPanel
onready var gauges_manager = $Camera/GaugesManager
onready var building_buttons_container = $Camera/StartBuildButton/BuildingButtonsContainer
onready var cooldowns_manager = $Camera/CooldownsManager

onready var building_ghost = $BuildingGhost
onready var building_ghost_occupied_space = $BuildingGhost/OccupiedSpaceArea
onready var building_ghost_occupied_collision = $BuildingGhost/OccupiedSpaceArea/CollisionShape2D


var is_placing_building = false
var type_to_build = null
var is_building_ghost_overlapped = false
var last_building = null

var player = null

func _on_start_build_button_pressed():
  building_buttons_container.show()

func _on_building_button_pressed(data) -> void:
  if GameManager.player_actor.is_dead:
    BuildingTooltip.hide()
    building_ghost.hide()
    building_buttons_container.hide()
  else:
    is_placing_building = true
    type_to_build = data
    building_ghost.global_position = get_global_mouse_position()
    var texture = load('res://assets/buildings/%s.png' % data._name)
    building_ghost.texture = texture
    building_ghost_occupied_collision.shape.extents = texture.get_size() / 2.0
    building_ghost.show()

func build_mode_off() -> void:
  is_placing_building = false
  building_buttons_container.hide()
  BuildingTooltip.hide()
  building_ghost.hide()
  

func place_building() -> void:
  var new_building = building_scene.instance()
  buildings_holder.add_child(new_building)
  new_building._initialize(player, type_to_build, get_global_mouse_position())
  connect_building(new_building)
  build_mode_off()

func place_castle(team: int, coords: Vector2):
  var new_castle = castle_scene.instance()
  buildings_holder.add_child(new_castle)
  new_castle.global_position = coords
  new_castle.team = team
  GameManager.team_castles[team] = new_castle
  connect_building(new_castle)

# methode pour raccorder les signaux d'un nouveau building
func connect_building(building):
  building.connect('player_entered_building', self, "_on_player_entered_building")
  building.connect('player_entered_building', building_window, "_on_player_entered_building")
  building.connect('player_exited_building', building_window, "_on_player_exited_building")
  building.connect('player_entered_owned_building', craft_panel, "_on_player_entered_owned_building")
  building.connect('player_entered_owned_building', refine_panel, "_on_player_entered_owned_building")
  building.connect('player_exited_building', craft_panel, "_on_player_exited_building")

func _on_player_entered_building(building, actor) -> void:
  storage_panel._initialize(building)
  refine_panel._initialize(building)
  if !!last_building:
    # deconnexion des signaux entre le craft et storage panel et le precedent building
    last_building.disconnect('craft_queue_changed', craft_panel, "_on_craft_queue_changed")
    last_building.disconnect('craft_progress_changed', craft_panel, "_on_craft_progress_changed")
    last_building.disconnect('stackable_storage_changed', storage_panel, "_on_stackable_storage_changed")
    last_building.disconnect('gold_storage_changed', storage_panel, "_on_building_gold_changed")
    last_building.disconnect('current_refine_changed', refine_panel, "_on_current_refine_changed")
    last_building.disconnect('refine_progress_changed', refine_panel, "_on_refine_progress_changed")
    craft_panel.disconnect('recipe_requested', last_building, '_on_recipe_requested')
    craft_panel.disconnect('cancel_requested', last_building, 'cancel_craft')
    storage_panel.disconnect('stackable_storage_requested', last_building, '_on_stackable_storage_requested')
    storage_panel.disconnect('stackable_withdrawal_requested', last_building, '_on_stackable_withdrawal_requested')
    storage_panel.disconnect('stackable_buy_requested', last_building, '_on_stackable_buy_requested')
    storage_panel.disconnect('stackable_sell_requested', last_building, '_on_stackable_sell_requested')
    refine_panel.disconnect('refine_requested', last_building, '_on_refine_requested')
    refine_panel.disconnect('refine_loop_toggled', last_building, '_on_refine_loop_toggled')
    if last_building is Castle:
      last_building.disconnect('health_changed', contribution_panel, '_on_health_changed')
      last_building.disconnect('upgrade_changed', contribution_panel, '_on_upgrade_changed')
      last_building.disconnect('instant_resurrection_stock_changed', resurrection_panel, '_on_instant_resurrection_stock_changed')

  building.connect('craft_queue_changed', craft_panel, "_on_craft_queue_changed")
  building.connect('craft_progress_changed', craft_panel, "_on_craft_progress_changed")
  building.connect('stackable_storage_changed', storage_panel, "_on_stackable_storage_changed")
  building.connect('gold_storage_changed', storage_panel, "_on_building_gold_changed")
  building.connect('current_refine_changed', refine_panel, "_on_current_refine_changed")
  building.connect('refine_progress_changed', refine_panel, "_on_refine_progress_changed")
  craft_panel.connect('recipe_requested', building, '_on_recipe_requested')
  craft_panel.connect('cancel_requested', building, 'cancel_craft')
  storage_panel.connect('stackable_storage_requested', building, '_on_stackable_storage_requested')
  storage_panel.connect('stackable_withdrawal_requested', building, '_on_stackable_withdrawal_requested')
  storage_panel.connect('stackable_buy_requested', building, '_on_stackable_buy_requested')
  storage_panel.connect('stackable_sell_requested', building, '_on_stackable_sell_requested')
  refine_panel.connect('refine_requested', building, '_on_refine_requested')
  refine_panel.connect('refine_loop_toggled', building, '_on_refine_loop_toggled')
  if building is Castle:
    building.connect('health_changed', contribution_panel, '_on_health_changed')
    building.connect('upgrade_changed', contribution_panel, '_on_upgrade_changed')
    building.connect('instant_resurrection_stock_changed', resurrection_panel, '_on_instant_resurrection_stock_changed')
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
  # instanciation du player
  player = load('res://entities/actor/player.tscn').instance()
  world.add_child(player)
  GameManager.player_actor = player
  SaveManager.load_actor_data(GameManager.player_name)
  
  for data in Data.buildings:
#    if data._name == "castle":
#      continue
    var new_button = building_button_scene.instance()
    building_buttons_container.add_child(new_button)
    new_button._initialize(data)
    new_button.connect("building_button_pressed", self, "_on_building_button_pressed")
    new_button.connect("building_button_right_pressed", self, "build_mode_off")
    # TODO connect inventory changed to button for legality of build attempt 
  building_buttons_container.hide()
  
  # dans ready car a faire après que le player soit instancié
  status_panel.initialize()
  
  self.remove_child(camera)
  player.add_child(camera)
  
  player.connect('gold_changed', inventory_panel, "_on_gold_changed")
  player.connect('weight_changed', inventory_panel, "_on_weight_changed")
  player.connect('inventory_changed', inventory_panel, "_on_inventory_changed")
  player.connect('health_changed', gauges_manager, '_on_player_health_changed')
  player.connect('stamina_changed', gauges_manager, '_on_player_stamina_changed')
  player.connect('mana_changed', gauges_manager, '_on_player_mana_changed')
  player.connect('experience_changed', status_panel, '_on_player_experience_changed')
  player.connect('gold_changed', storage_panel, "_on_gold_changed")
  player.connect('inventory_changed', storage_panel, "_on_inventory_changed")
  player.connect('tech_list_changed', cooldowns_manager, "_on_tech_list_changed")
  player.connect('cooldowns_changed', cooldowns_manager, "_on_player_cooldowns_changed")
  cooldowns_manager.connect("hotkeys_switched", player, "_on_hotkeys_switch_requested")
  
  # zone de seed pour test
  var new_armor = Data.crafts[0].product.new()
  player.inventory.gear['body'] = new_armor
  player.add_item(Data.crafts[21].product.new())
  player.add_item(Data.crafts[22].product.new())
  player.add_item(StaminaPotion.new())
  player.add_item(StaminaPotion.new())
  player.add_item(StaminaPotion.new())
  player.emit_signal('inventory_changed', player.inventory)
  player.add_resource("ore", 15)
  player.add_resource("iron", 15)
  player.add_resource("leather", 8)
  player.add_resource("skin", 8)
  player.add_resource("fabric", 8)
  player.add_resource("cristal", 8)
  player.add_resource("stone", 8)
  player.gain_xp("jewels", 300)
  
#  player.gain_xp("light_armors", 200)
#  player.gain_xp("leatherwork", 200)
  player.gold += 15
  player.health -= 6
  
  place_castle(0, Vector2(10,10))

