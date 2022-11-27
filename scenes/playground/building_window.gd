extends TabContainer

func _on_player_entered_building(building, player):
  set_tab_hidden(0, building.building_owner != player)
  set_tab_hidden(1, building.building_owner != player)
  set_tab_hidden(3, (!player.is_dead || building is Castle == false))
  set_tab_hidden(4, building is Castle == false)
  show()
  
func _on_player_exited_building() -> void:
  hide()
  CraftTooltip.hide()
  
func _on_player_resurrected():
  set_tab_hidden(2, true)

func _ready():
  hide()
  set_tab_title(0, "Fabrication")
  set_tab_title(1, "Rafinage")
  set_tab_title(2, "Commerce")
  set_tab_title(3, "Résurrection")
  set_tab_title(4, "Contributions")
