extends CanvasLayer

onready var panel = $Panel
onready var title_label = $Panel/Title
onready var mastery_label = $Panel/Mastery
onready var stats_label = $Panel/Stats
onready var description_label = $Panel/Description

var neutral_offset: Vector2 = Vector2(20 ,-20)

func display(item):
  title_label.text = item.label
  if item is Equipable:
    stats_label.text = item.final_stats_text
  description_label.text = item.description
  panel.show()

func hide():
  panel.hide()

func _ready():
  panel.hide()

func _process(_delta):
  if panel.visible:
    # TODO gestion decalage si pas de place pour display
    panel.rect_global_position = get_viewport().get_mouse_position() + neutral_offset
