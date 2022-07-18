extends CanvasLayer

onready var panel = $Panel
onready var label = $Panel/Label


var neutral_offset: Vector2 = Vector2(20 ,-20)

func display(building_data: BuildingData):
  label.text = building_data.label + "\n\n"
  label.text += "Cout: " + building_data.resources_text
  panel.show()

func hide():
  panel.hide()

func _ready():
  panel.hide()

func _process(_delta):
  if panel.visible:
    # TODO gestion decalage si pas de place pour display
    panel.rect_global_position = get_viewport().get_mouse_position() + neutral_offset
