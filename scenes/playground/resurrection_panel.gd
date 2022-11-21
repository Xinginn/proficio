extends Panel

onready var instant_resurrection_button: Button = $InstantButton
onready var instant_resurrection_stock_label: Label = $InstantButton/ResurrectionStockLabel
onready var slow_resurrection_progress_bar: ProgressBar = $SlowButton/SlowProgressBar


func _on_slow_button_pressed():
  GameManager.player_actor.start_resurrecting()
  GameManager.player_actor.connect('resurrection_progress_changed', self, '_on_player_resurrection_progress_changed')
  GameManager.player_actor.connect('resurrection_ended', self, '_on_player_resurrection_ended')
  
func _on_player_resurrection_progress_changed(current, maxi):
  slow_resurrection_progress_bar.max_value = maxi
  slow_resurrection_progress_bar.value = current
  
func _on_player_resurrection_ended():
  emit_signal('player_resurected')

func _on_instant_resurrection_stock_changed(value):
  instant_resurrection_stock_label.text = "Stock: %d" % value
  instant_resurrection_button.disabled = (value == 0)  
  
func _on_instant_button_pressed():
  var castle = GameManager.team_castles[GameManager.player_actor.team]
  castle.require_instant_resurrection(GameManager.player_actor)
