extends Control

onready var character_list_menu = $NewGamePanel/CharacterListMenu
onready var character_list_popup = character_list_menu.get_popup()
onready var name_label = $NameLabel


var characters = []

func load_all_characters():
  characters = []
  character_list_popup.clear()
  
  var files = Utils.get_files_in_directory('user://saves')
  for file in files:
    var chara_name = file.replace('.json', '')
    characters.append(chara_name)
    character_list_popup.add_item(chara_name)
  
  
func _on_character_selected(id):
  var data = SaveManager.load_json(characters[id])
  print(data)
  
func _on_play_button_pressed():
  pass # Replace with function body.


func _ready() -> void:
  load_all_characters()
  character_list_popup.connect('id_pressed', self, '_on_character_selected')
