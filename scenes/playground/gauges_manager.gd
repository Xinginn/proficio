extends HBoxContainer

onready var health_regain_bar: ProgressBar = $HealthRegainBar
onready var health_bar: ProgressBar = $HealthRegainBar/HealthBar
onready var health_label: Label = $HealthRegainBar/HealthBar/Label
onready var stamina_regain_bar: ProgressBar = $StaminaRegainBar
onready var stamina_bar: ProgressBar = $StaminaRegainBar/StaminaBar
onready var stamina_label: Label = $StaminaRegainBar/StaminaBar/Label
onready var mana_regain_bar: ProgressBar = $ManaRegainBar
onready var mana_bar: ProgressBar = $ManaRegainBar/ManaBar
onready var mana_label: Label = $ManaRegainBar/ManaBar/Label

func _on_player_health_changed(current, maxi, regain) -> void:
  health_bar.value = current
  health_bar.max_value = maxi
  health_regain_bar.value = regain + current
  health_regain_bar.max_value = maxi
  health_label.text = "%.2f / %d" % [current, maxi]

  
func _on_player_stamina_changed(current, maxi, regain) -> void:
  stamina_bar.value = current
  stamina_bar.max_value = maxi
  stamina_regain_bar.value = regain + current
#  print(current, " ", regain, " ", regain + current)
  stamina_regain_bar.max_value = maxi
  stamina_label.text = "%.2f / %d" % [current, maxi]

func _on_player_mana_changed(current, maxi, regain) -> void:
  mana_bar.value = current
  mana_bar.max_value = maxi
  mana_regain_bar.value = regain + current
  mana_regain_bar.max_value = maxi
  mana_label.text = "%.2f / %d" % [current, maxi]
