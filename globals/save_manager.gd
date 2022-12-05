extends Node

func load_json(file_name: String):
	var file = File.new()
	var path: String = "user://saves/" + file_name + ".json"
	if !file.file_exists(path):
		print("Warning! no file at " + path)
		return null
	file.open(path, File.READ)
	var data = parse_json(file.get_as_text())
	file.close()
	return data
	
func load_actor_data(_name: String) -> void:
	var actor_data: Dictionary = load_json(_name)
	if actor_data == null:
		return
	GameManager.player_actor.load_data(actor_data)
	
func save_actor_data(actor: Actor) -> void:
	var actor_data = actor.get_data()
	var save_path: String = "user://saves/%s.json" % actor._name
	var file = File.new()
	file.open(save_path, File.WRITE)
	file.store_line(to_json(actor_data))
	file.close()
