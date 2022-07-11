extends TextureButton

var slot

signal inventory_item_pressed(slot)

func _initialize(_slot):
  slot = _slot
  var loaded_texture = null
  # TODO retirer cette sécurité en post_test
  var default_texture = load('res://assets/icons/default.png')

  if _slot is String:     # dans ce cas, c'est un slot de l'equipement
    loaded_texture = load("res://assets/icons/%s.png" % GameManager.player_actor.inventory.gear[slot])
  elif _slot is int:  # sinon, c'est un slot des objets en inventaire
    loaded_texture = load("res://assets/icons/%s.png" % GameManager.player_actor.inventory.items[slot]._name)
    
  texture_normal = loaded_texture if !!loaded_texture else default_texture
    
func _on_pressed():
  emit_signal('inventory_item_pressed', slot)
