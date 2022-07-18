extends HBoxContainer

onready var health_bar: ProgressBar = $HealthBar
onready var health_label: Label = $HealthBar/Label
onready var stamina_bar: ProgressBar = $StaminaBar
onready var stamina_label: Label = $StaminaBar/Label
onready var mana_bar: ProgressBar = $ManaBar
onready var mana_label: Label = $ManaBar/Label

func _on_player_health_changed(current, maxi) -> void:
  health_bar.value = current
  health_bar.max_value = maxi
  health_label.text = "%.2f / %d" % [current, maxi]
  
func _on_player_stamina_changed(current, maxi) -> void:
  stamina_bar.value = current
  stamina_bar.max_value = maxi
  stamina_label.text = "%.2f / %d" % [current, maxi]

func _on_player_mana_changed(current, maxi) -> void:
  mana_bar.value = current
  mana_bar.max_value = maxi
  mana_label.text = "%.2f / %d" % [current, maxi]
