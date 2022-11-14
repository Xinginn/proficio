extends Panel

onready var repair_progress_bar: ProgressBar = $RepairButton/RepairProgress
onready var upgrade_progress_bar: ProgressBar = $UpgradeButton/UpgradeProgress

func assign_contribution_to_actor(_name, actor):
  actor.current_contribution = _name
  actor.contribution_progress = 0.0
  actor.connect('contribution_finished', self, '_on_actor_finished_contribution')

func _on_contribution_button_pressed(_name):
  var player = GameManager.player_actor
  if player.current_contribution == _name:
    return
  if player.has_resources(Data.contributions[_name]["cost"]):
    assign_contribution_to_actor(_name, player)
    for resource_name in Data.contributions[_name]["cost"].keys():
      player.remove_resource(resource_name, Data.contributions[_name]["cost"][resource_name])
    player.connect('contribution_progress_changed', self, '_on_player_contribution_progress_changed')

func _on_player_contribution_progress_changed(_name, value):
  match _name:
    "repair":
      repair_progress_bar.value = value
    "upgrade":
      upgrade_progress_bar.value = value
    _:
      print('Warning! incorrect contribution type:', _name)
      
func _on_actor_finished_contribution(_name, actor):
  actor.current_contribution = ""
  actor.disconnect('contribution_finished', self, '_on_actor_finished_contribution')
  if actor == GameManager.player_actor:
    actor.disconnect('contribution_progress_changed', self, '_on_player_contribution_progress_changed') 
  print('should handle contribution effects')

func _ready():
  repair_progress_bar.max_value = Data.contributions["repair"]["needed_progress"]
  upgrade_progress_bar.max_value = Data.contributions["upgrade"]["needed_progress"]
