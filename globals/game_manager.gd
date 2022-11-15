extends Control

onready var animation_player = $AnimationPlayer
onready var black_panel = $CanvasLayer/BlackPanel

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var player_name: String = "mouette"
var player_actor = null

var world_size: int = 1
var forest_ratio: int = 1

var team_castles = {0: null, 1: null}
#
#signal to_black_finished
#signal from_black_finished

# funcs de transitions
func to_black(_speed: float = 1.0):
  animation_player.play('to_black', -1, _speed)

func from_black(_speed: float = 1.0):
  animation_player.play('from_black', -1, _speed)

# funcs de hide et show HUD
#func hide_HUD() -> void:
#  HUD.hide()
#
#func show_HUD() -> void:
#  HUD.show()

func change_scene(scene_path: String):
  to_black()
  yield(self, 'to_black_finished')
  var _result = get_tree().change_scene(scene_path)
  from_black()

func _on_animation_finished(anim_name):
  emit_signal(anim_name + '_finished')

func _ready():
  rng.randomize()
