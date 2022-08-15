extends TabContainer


func _on_player_entered_building(_building_data):
  show()
  
func _on_player_exited_building() -> void:
  hide()
  CraftTooltip.hide()

func _ready():
  hide()
  set_tab_title(0, "Fabrication")
  set_tab_title(1, "Stock")
