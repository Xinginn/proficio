extends Control

const stat_summary_scene = preload('res://scenes/main_screen/stat_summary_block/stat_summary_block.tscn')

onready var character_list_menu = $NewGamePanel/CharacterListMenu
onready var character_list_popup = character_list_menu.get_popup()
onready var name_label = $NameLabel
onready var animated_sprite = $AnimatedSprite
onready var stats_container = $ScrollContainer/StatsContainer

var characters = []
var selected_chara_name = null

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
  selected_chara_name = data["_name"]
  name_label.text = data["_name"]
  animated_sprite.frames = load('res://tres/spriteframes/actors/%s.tres' % data["sprite_path"])
  animated_sprite.animation = 'walk_down'
  for child in stats_container.get_children():
    child.queue_free()
  for attribute_data in data["attributes"].values():
    if attribute_data["level"] > 1:
      var new_summary = stat_summary_scene.instance()
      stats_container.add_child(new_summary)
      new_summary._initialize(attribute_data)
      
  
func _on_launch_game_button_pressed():
  if !!selected_chara_name:
    GameManager.player_name = selected_chara_name
    GameManager.change_scene('res://scenes/playground/playground.tscn')
    print('a')

func _ready() -> void:
  load_all_characters()
  character_list_popup.connect('id_pressed', self, '_on_character_selected')
