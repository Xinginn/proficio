extends TextureButton

const empty_texture: Texture = preload('res://assets/empty_48.png')
var slot

signal inventory_item_pressed(slot)

func _initialize(_slot):
  slot = _slot

  var item
  if _slot is String: 
    # dans ce cas, c'est un slot de l'equipement
    item = GameManager.player_actor.inventory.gear[slot]   
  elif _slot is int: 
    # sinon, c'est un slot des objets en inventaire
    item = GameManager.player_actor.inventory.items[slot]
  else:
    print('ERROR! Unexpected slot type for inventory_item')
  if !!item:
    texture_normal = load("res://assets/icons/%s.png" % item._name)
    $MarginContainer/StackLabel.text = str(item.stack) if item is Consumable else ""
  else:
    texture_normal = empty_texture
    
func _on_pressed():
  emit_signal('inventory_item_pressed', slot)
  
func _on_gui_input(event):
  if event is InputEventMouseButton:
    if event.button_index == BUTTON_RIGHT and event.pressed:
      if slot is int:
        if GameManager.player_actor.inventory.items[slot] is Consumable:
          GameManager.player_actor.consume_item(slot)

func _on_mouse_entered():
  var item
  if slot is String: 
    # dans ce cas, c'est un slot de l'equipement
    item = GameManager.player_actor.inventory.gear[slot]   
  elif slot is int: 
    # sinon, c'est un slot des objets en inventaire
    item = GameManager.player_actor.inventory.items[slot]
  if !!item:
    ItemTooltip.display(item)

func _on_mouse_exited():
  ItemTooltip.hide()

