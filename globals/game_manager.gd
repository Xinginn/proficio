extends Control

onready var animation_player = $AnimationPlayer
onready var black_panel = $CanvasLayer/BlackPanel
onready var game_over_panel = $CanvasLayer/GameOverPanel


var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var player_name: String = "mouette"
var player_actor = null

var world_size: int = 1
var forest_ratio: int = 1

var team_castles = {0: null, 1: null}

signal to_black_finished
signal from_black_finished

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
	game_over_panel.hide()

func _on_castle_destroyed(castle) -> void:
	# TODO check for win
	if castle.team == player_actor.team:
		print('TODO: handle player data save')
		game_over_panel.show()


func _on_main_menu_button_pressed():
	game_over_panel.hide()
	change_scene("res://scenes/main_screen/main_screen.tscn")
