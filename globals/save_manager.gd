extends Node

func load_json(file_name: String):
  var file = File.new()
  var path: String = "user://" + file_name + ".json"
  if !file.file_exists(path):
    print("Warning! no file at " + path)
    return null
  file.open(path, File.READ)
  var data = parse_json(file.get_as_text())
  file.close()
  return data
  
func load_player_data(_name: String) -> void:
  var save_name: String = "save_%s" % _name
  var player_data: Dictionary = load_json(save_name)
  if player_data == null:
    return
  GameManager.player_actor.load_data(player_data)
  
func save_player_data() -> void:
  var player = GameManager.player_actor
  var player_data = player.get_data()
  
  print(player_data)
  
  var save_path: String = "user://save_%s.json" % player._name
  var file = File.new()
  file.open(save_path, File.WRITE)
  file.store_line(to_json(player_data))
  file.close()
