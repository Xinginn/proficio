extends TextureButton

var craft_data: CraftData
var expected_product: Item

signal recipe_button_pressed(data)

func _initialize(_data: CraftData):
  craft_data = _data
  expected_product = _data.product.new(GameManager.player_actor)

  var texture = load('res://assets/icons/' + expected_product._name + ".png")
  if !!texture:
    $Icon.texture = texture
  $Label.text = expected_product.label

func _on_mouse_entered():
  CraftTooltip.display(craft_data, expected_product)

func _on_mouse_exited():
  CraftTooltip.hide()

func _on_pressed():
  emit_signal('recipe_button_pressed', craft_data)
