extends Control

const TARGET_Y = -15

onready var tween: Tween = $Tween
onready var label: Label = $Label
onready var timer: Timer = $Timer

func init(text: String, wait_time = 1):
  label.text = text
  tween.interpolate_property(label, "rect_position:y",
        0, -25, 0.4,
        Tween.TRANS_LINEAR, Tween.EASE_OUT)
  tween.interpolate_property(label, "modulate:a",
        0.0, 1.0, 0.2,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
  timer.wait_time = wait_time
  timer.start()
  var _result = tween.start()
  
func _ready():
  label.text = ""
  
func _on_timer_timeout():
  queue_free()
