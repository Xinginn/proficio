extends Panel

const stat_block_scene: PackedScene = preload('res://entities/stat_block/stat_block.tscn')

onready var caracs_container: VBoxContainer = $ScrollContainer/VBoxContainer/CaracsContainer
onready var skills_container: VBoxContainer = $ScrollContainer/VBoxContainer/SkillsContainer
onready var masteries_container: VBoxContainer = $ScrollContainer/VBoxContainer/MasteriesContainer

func initialize():
  for key in Dictionaries.attribute_names.keys():
    var new_block = stat_block_scene.instance()
    if Dictionaries.caracs.has(key):
      caracs_container.add_child(new_block)
    elif Dictionaries.skills.has(key):
      skills_container.add_child(new_block)
    else:
      masteries_container.add_child(new_block)
    new_block.update_display(key)

# TODO mettre uniquement le nom et le type dans le signal, pour recuperer son 
# index et eviter de reboucler sur tous les attributs
func _on_player_experience_changed():
  for i in range(Dictionaries.caracs.size()):
    caracs_container.get_child(i).update_display(Dictionaries.caracs[i])
  for i in range(Dictionaries.skills.size()):
    skills_container.get_child(i).update_display(Dictionaries.skills[i])
  for i in range(Dictionaries.masteries.size()):
    masteries_container.get_child(i).update_display(Dictionaries.masteries[i])

func toggle_visible():
  if visible:
    hide()
  else:
    show()

func _ready():
  hide()

func _unhandled_input(event):
  if event is InputEventKey:
    if !event.pressed and event.scancode == KEY_K:
      toggle_visible()
