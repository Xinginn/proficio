extends Panel

const inventory_item_scene: PackedScene = preload('res://entities/inventory_item/inventory_item.tscn')
const resource_stock_scene: PackedScene = preload('res://entities/resource_stock_display/resource_stock_display.tscn')

const LINE_TEXTURE = preload('res://assets/grid_line.png')

onready var gold_label: Label = $GoldIcon/Label

onready var head_button: TextureButton = $Gear/HeadButton
onready var body_button: TextureButton = $Gear/BodyButton
onready var main_hand_button: TextureButton = $Gear/MainHandButton
onready var off_hand_button: TextureButton = $Gear/OffHandButton
onready var feet_button: TextureButton = $Gear/FeetButton
onready var right_ring_button: TextureButton = $Gear/RightRingButton
onready var left_ring_button: TextureButton = $Gear/LeftRingButton

onready var inventory_lines_container = $ScrollContainer/LinesContainer
onready var items_grid = $ScrollContainer/MarginContainer/ItemsGrid

var resource_stock_displays = {}
var gear_buttons = {}
var armed_slot = null

func _on_gold_changed(value) -> void:
  gold_label.text = str(value)

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
  for i in range( int( max(size/10, 2) ) ):
    var new_texture_rect = TextureRect.new()
    inventory_lines_container.add_child(new_texture_rect)
    new_texture_rect.texture = LINE_TEXTURE
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
    print('should swap')
    # ici on doit faire une swap
    # gerer l'affichage
    # vider armed_slot
  else:
    armed_slot = _slot

func _ready():
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
