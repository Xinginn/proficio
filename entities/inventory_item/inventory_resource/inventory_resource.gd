extends TextureButton

const empty_texture: Texture = preload('res://assets/empty_48.png')

var resource_name: String
var quantity: int

func _initialize(_name):
  resource_name = _name
  if !!GameManager.player_actor:
    update_quantity()
  var resource_texture = load('res://assets/icons/%s.png' % _name)
  texture_normal = resource_texture if !!resource_texture else empty_texture 

func update_quantity():
  quantity = GameManager.player_actor.inventory.resources[resource_name]
  $MarginContainer/StackLabel.text = str(quantity)
