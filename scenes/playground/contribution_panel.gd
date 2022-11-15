extends Panel

onready var repair_progress_bar: ProgressBar = $RepairButton/RepairProgress
onready var upgrade_progress_bar: ProgressBar = $UpgradeButton/UpgradeProgress

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
