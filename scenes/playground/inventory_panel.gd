extends Panel

const inventory_item_scene: PackedScene = preload('res://entities/inventory_item/inventory_item.tscn')
const resource_stock_scene: PackedScene = preload('res://entities/resource_stock_display/resource_stock_display.tscn')
const grid_line_scene: PackedScene = preload('res://entities/inventory_grid_line/inventory_grid_line.tscn')

onready var head_button: TextureButton = $Gear/HeadButton
onready var body_button: TextureButton = $Gear/BodyButton
onready var main_hand_button: TextureButton = $Gear/MainHandButton
onready var off_hand_button: TextureButton = $Gear/OffHandButton
onready var feet_button: TextureButton = $Gear/FeetButton
onready var right_ring_button: TextureButton = $Gear/RightRingButton
onready var left_ring_button: TextureButton = $Gear/LeftRingButton

onready var gold_label: Label = $GoldIcon/Label
onready var weight_label: Label = $WeightIcon/Label
onready var inventory_lines_container = $ScrollContainer/LinesContainer
onready var items_grid = $ScrollContainer/MarginContainer/ItemsGrid
onready var item_ghost = $ItemGhost

var resource_stock_displays = {}
var gear_buttons = {}
var armed_slot = null setget _set_armed_slot

func _set_armed_slot(value):
  armed_slot = value
  match typeof(value):
    TYPE_INT:
      item_ghost.texture = load("res://assets/icons/%s.png" % GameManager.player_actor.inventory.items[value]._name)
      item_ghost.show()
    TYPE_STRING:  
      item_ghost.texture = load("res://assets/icons/%s.png" % GameManager.player_actor.inventory.gear[value]._name)
      item_ghost.show()
    TYPE_NIL:
      item_ghost.texture = null
      item_ghost.hide()

func toggle_visible():
  if visible:
    armed_slot = null
    hide()
  else:
    show()

func _on_gold_changed(value) -> void:
  gold_label.text = str(value)
  
func _on_weight_changed(total, maxi) -> void:
  weight_label.text = "%.2f / %.2f" % [total, maxi]
  if total > maxi:
    weight_label.add_color_override("font_color", Color(1,0,0,1))
  else:
    weight_label.add_color_override("font_color", Color(1,1,1,1))

func _on_inventory_changed(_inventory: Inventory) -> void:
  for key in gear_buttons.keys():
    gear_buttons[key]._initialize(key)
  # cleanup des anciennes lignes de background d'inventaire et des items
  for child in inventory_lines_container.get_children():
    child.queue_free()
  for child in items_grid.get_children():
    child.queue_free()
  # creation des lignes et items
  var size = _inventory.items.size()
  for _i in range( int( max(size/10, 2) ) ):
    var new_grid_line = grid_line_scene.instance()
    inventory_lines_container.add_child(new_grid_line)
    new_grid_line.connect("line_clicked", self, "_on_line_clicked")
  for i in range(size):
    var new_item = inventory_item_scene.instance()
    items_grid.add_child(new_item)
    new_item._initialize(i)
    new_item.connect('inventory_item_pressed', self, '_on_inventory_item_pressed')

func _on_resources_changed(_resources: Dictionary):
  for key in _resources.keys():
    resource_stock_displays[key].stock = _resources[key]
  
func _on_inventory_item_pressed(_slot):
  if str(_slot) == str(armed_slot): 
    return
  if armed_slot != null:    
    if typeof(armed_slot) != typeof(_slot):
      # dans ce cas, un et un seul des item concerné viens de la gear. il faut trouver lequel
      var gear_slot = _slot if typeof(_slot) == TYPE_STRING else armed_slot
      var item_slot = _slot if typeof(_slot) == TYPE_INT else armed_slot

      var inventory = GameManager.player_actor.inventory
      if "slots" in inventory.items[item_slot]: # check si possede cet attribut, reservé aux equippable
        if inventory.items[item_slot].slots.has(gear_slot):
          GameManager.player_actor.swap_gear_and_inventory_item(gear_slot, item_slot)
        else:
          self.armed_slot = null
          return
      else:
        self.armed_slot = null
        return
      self.armed_slot = null
    elif typeof(_slot) == TYPE_INT:
      # deux identique, au moins un slot int => les deux sont dans items. Donc swap inconditionnel
      GameManager.player_actor.swap_inventory_items(_slot, armed_slot)
      self.armed_slot = null
  # si on avait pas encore un slot clické precedemment
  else:
    self.armed_slot = _slot

func _on_line_clicked():
  if !!armed_slot:
    if typeof(armed_slot) == TYPE_STRING:
      GameManager.player_actor.unequip(armed_slot)
      self.armed_slot = null

func _ready():
  hide()
  # boucle pour connecter et pré-renseigner les gear button sans forcément avoir un player ready
  for key in ["head", "body", "main_hand", "off_hand", "feet", "right_ring", "left_ring"]:
    gear_buttons[key] = get("%s_button" % key)
    gear_buttons[key].slot = key
    gear_buttons[key].connect('inventory_item_pressed', self, '_on_inventory_item_pressed')
  var resources_container = $ResourcesContainer
  for key in Data.resource_dictionary.keys():
    var new_resource = resource_stock_scene.instance()
    resources_container.add_child(new_resource)
    new_resource.texture = load('res://assets/icons/resource_%s.png' % key)
    resource_stock_displays[key] = new_resource

func _process(_delta):
  if armed_slot != null:
    item_ghost.global_position = get_global_mouse_position()

func _unhandled_input(event):
  if event is InputEventMouseButton:
    if event.button_index == BUTTON_RIGHT and event.pressed:
      self.armed_slot = null
  elif event is InputEventKey:
    if !event.pressed and event.scancode == KEY_I:
      toggle_visible()
