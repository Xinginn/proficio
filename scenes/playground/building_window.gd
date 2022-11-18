extends TabContainer


func _on_player_entered_building(_building_data, is_owner):
  # set_tab_hidden(0, !is_owner) TODO migrer en 3.4
  show()
  
func _on_player_exited_building() -> void:
  hide()
  CraftTooltip.hide()

func _ready():
  hide()
  set_tab_title(0, "Fabrication")
  set_tab_title(1, "Stock")
