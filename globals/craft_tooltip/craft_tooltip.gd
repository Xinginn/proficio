extends CanvasLayer

onready var panel = $Panel
onready var icon = $Panel/Icon
onready var title_label = $Panel/Title
onready var stats_label = $Panel/Stats
onready var description_label = $Panel/Description
onready var resources_label = $Panel/Resources

var neutral_offset: Vector2 = Vector2(20 ,-20)

func display(craft_data: CraftData, expected_product):
  title_label.text = expected_product.label
  if "stats_text" in expected_product:
    stats_label.text = expected_product.stats_text
  description_label.text = expected_product.description
  resources_label.text = "Coût: " + craft_data.resources_text
  panel.show()

func hide():
  panel.hide()

func _ready():
  panel.hide()

func _process(_delta):
  if panel.visible:
    # TODO gestion decalage si pas de place pour display
    panel.rect_global_position = get_viewport().get_mouse_position() + neutral_offset
