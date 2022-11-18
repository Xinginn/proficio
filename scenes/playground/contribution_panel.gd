extends Panel

onready var repair_progress_bar: ProgressBar = $RepairButton/RepairProgress
onready var upgrade_progress_bar: ProgressBar = $UpgradeButton/UpgradeProgress

onready var health_regain_bar: ProgressBar = $HealthRegainBar
onready var health_bar: ProgressBar = $HealthRegainBar/HealthBar
onready var health_label: Label = $HealthRegainBar/HealthBar/Label
onready var upgrade_regain_bar: ProgressBar = $UpgradeRegainBar
onready var upgrade_bar: ProgressBar = $UpgradeRegainBar/UpgradeBar
onready var upgrade_label: Label = $UpgradeRegainBar/UpgradeBar/Label

func _on_health_changed(current, maxi, regain) -> void:
  health_bar.value = current
  health_bar.max_value = maxi
  health_regain_bar.value = regain + current
  health_regain_bar.max_value = maxi
  health_label.text = "%.2f / %d" % [current, maxi]
  
func _on_upgrade_changed(current, maxi, regain) -> void:
  upgrade_bar.value = current
  upgrade_bar.max_value = maxi
  upgrade_regain_bar.value = regain + current
  upgrade_regain_bar.max_value = maxi
  upgrade_label.text = "%.2f / %d" % [current, maxi]

func _on_contribution_button_pressed(_name):
  var player = GameManager.player_actor
  # aucun effet si c'est le même que celui en cours
  if player.current_contribution == _name:
    return
  # on annule et rembourse le précedent, le cas échéant
  if player.current_contribution != "":
    player.cancel_contribution()
  if player.has_resources(Data.contributions[_name]["cost"]):
    player.start_contribution(_name)

func _on_player_contribution_progress_changed(_name, value):
  match _name:
    "repair":
      repair_progress_bar.value = value
    "upgrade":
      upgrade_progress_bar.value = value
    _:
      print('Warning! incorrect contribution type:', _name)

func _ready():
  repair_progress_bar.max_value = Data.contributions["repair"]["needed_progress"]
  upgrade_progress_bar.max_value = Data.contributions["upgrade"]["needed_progress"]
