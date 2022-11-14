extends Panel

func _on_repair_button_pressed():
  var player = GameManager.player_actor
  if player.has_resources({'stone': 4}):
    player.contribution_progress = 0.0
    player.current_contribution = "repair"
    for resource_name in Data.contributions["repair"]["cost"].keys():
      player.remove_resource(resource_name, Data.contributions["repair"]["cost"][resource_name])
      
    
func _on_player_contribution_progress_changed(_name, value):
  pass
    
    
func _on_upgrade_button_pressed():
  print('upgrade')

func _on_actor_completed_contribution(actor, contribution_name):
  pass
