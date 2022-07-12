extends Control

onready var HUD = $HUD

onready var animation_player = $AnimationPlayer
onready var black_panel = $CanvasLayer/BlackPanel

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var save_number: int = 1
var player_actor = null

var world_width: int = 5
var world_height: int = 3

signal to_black_finished
signal from_black_finished

# funcs de transitions
func to_black(_speed: float = 1.0):
  animation_player.play('to_black', -1, _speed)

func from_black(_speed: float = 1.0):
  animation_player.play('from_black', -1, _speed)

# funcs de hide et show HUD
func hide_HUD() -> void:
  HUD.hide()

func show_HUD() -> void:
#  stamina_bar.value = Player.stamina
#  health_bar.value = Player.health
#  food_bar.value = Player.food
  HUD.show()

func change_scene(scene_path: String):
  to_black()
  yield(self, 'to_black_finished')
  get_tree().change_scene(scene_path)
  from_black()

func _on_animation_finished(anim_name):
  emit_signal(anim_name + '_finished')

func _ready():
#  Player.connect('stamina_changed', self, "_on_stamina_changed")
#  Player.connect('food_changed', self, "_on_food_changed")
#  Player.connect('health_changed', self, "_on_health_changed")
#  Player.connect('max_health_changed', self, "_max_on_health_changed")
#  Player.connect('money_changed', self, "_on_money_changed")
#  Player.connect('age_changed', self, "_on_age_changed")
#  Player.connect('life_span_changed', self, "_on_life_span_changed")
  rng.randomize()
