extends Control

const stat_summary_scene = preload('res://scenes/main_screen/stat_summary_block/stat_summary_block.tscn')
const create_character_scene = preload('res://scenes/main_screen/create_caracter.tscn')

onready var new_game_panel: Panel = $NewGamePanel
onready var character_list_menu = $NewGamePanel/CharacterMenu/CharacterListMenu
onready var character_list_popup = character_list_menu.get_popup()
onready var name_label = $NewGamePanel/CharacterMenu/NameLabel
onready var animated_sprite = $NewGamePanel/CharacterMenu/AnimatedSprite
onready var stats_container = $NewGamePanel/CharacterMenu/ScrollContainer/StatsContainer
onready var create_character_panel = $NewGamePanel/CreateCharacter
onready var world_size_label: Label = $NewGamePanel/MapMenu/WorldSize/Label
onready var forest_label: Label = $NewGamePanel/MapMenu/Forest/Label

var characters = []
var selected_chara_name = null
var world_size = 20 setget _set_world_size
var forest = 1 setget _set_forest

func _set_world_size(value):
  world_size = clamp(value, 10, 50)
  world_size_label.text = "%d x %d" % [world_size, world_size]
  
func _set_forest(value):
  forest = clamp(value, 0, 4)
  var forest_labels = ["Aucune", "Rares", "Eparses", "Nombreuses", "Omniprésentes"]
  forest_label.text = forest_labels[forest]

func check_for_game_launchable():
  # TODO mettre toutes les verifs
  if !!selected_chara_name:
    $NewGamePanel/LaunchGameButton.disabled = false

func load_characters_list():
  characters = ["Nouveau..."]
  character_list_popup.clear()
  character_list_popup.add_item("Nouveau...")
  var files = Utils.get_files_in_directory('user://saves')
  for file in files:
    var chara_name = file.replace('.json', '')
    characters.append(chara_name)
    character_list_popup.add_item(chara_name)  

func _on_character_selected(id):
  if id == 0:
    create_character_panel.show()
  else:  
    load_character_infos(characters[id])

func load_character_infos(_name):
  var data = SaveManager.load_json(_name)
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
  check_for_game_launchable()

func _on_character_created(_name):
  load_characters_list()
  load_character_infos(_name)
  create_character_panel.disconnect('character_created', self, '_on_character_created')
  $NewGamePanel.remove_child(create_character_panel)
  var new_panel = create_character_scene.instance()
  $NewGamePanel.add_child(new_panel)
  create_character_panel = $NewGamePanel/CreateCharacter
  create_character_panel.connect('character_created', self, '_on_character_created')
  create_character_panel.hide()

func _on_launch_game_button_pressed():
  GameManager.player_name = selected_chara_name
  GameManager.change_scene('res://scenes/playground/playground.tscn')

func _on_new_game_button_pressed():
  new_game_panel.show()

func _on_world_size_slider_value_changed(value):
  self.world_size = value

func _on_forest_slider_value_changed(value):
  self.forest = value

func _ready() -> void:
  load_characters_list()
  character_list_popup.connect('id_pressed', self, '_on_character_selected')
  new_game_panel.hide()
  create_character_panel.connect('character_created', self, '_on_character_created')
