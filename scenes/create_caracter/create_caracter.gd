extends Panel

onready var race_choice_label= $RaceChoiceLabel
onready var race_menu: MenuButton = $RaceChoiceLabel/MenuButton
onready var sprite_menu: MenuButton = $ApparenceLabel/MenuButton
onready var description_text = $DescriptionText
onready var stats_text = $StatsText
onready var animated_sprite = $ApparenceLabel/AnimatedSprite


var selected_race = null setget _set_race
var selected_sprite_name = null
var sprites = []

func _set_race(value) -> void:
  if value != selected_race:
    selected_race = value
    # TODO load des images pour la race

func get_race_sprites() -> Array:
  var sprite_names = []
  var files = Utils.get_files_in_directory('res://tres/spriteframes/actors')
  for file in files:
    if file.begins_with(Data.races[selected_race]["name"]):
      sprite_names.append(file.replace('.tres', ''))
  print(sprite_names)
  return sprite_names

func _on_race_selected(id):
  self.selected_race = id
  var race = Data.races[id]
  race_choice_label.text = "Race: %s" % race["label"]
  description_text.text = race["description"]
  stats_text.text = race["stats_text"]
  var sprite_popup = sprite_menu.get_popup()
  sprites = get_race_sprites()
  for sprite in sprites:
    sprite_popup.add_item(sprite)

func _on_sprite_selected(id):
  print(sprites[id])
  animated_sprite.frames = load('res://tres/spriteframes/actors/%s.tres' % sprites[id])
  animated_sprite.animation = "walk_down"
  animated_sprite.frame = 0
  animated_sprite.playing = true
  

func _ready():
  var race_popup = race_menu.get_popup()
  for race in Data.races:
    race_popup.add_item(race["label"])
  race_popup.connect('id_pressed', self, "_on_race_selected")
  var sprite_popup = sprite_menu.get_popup()
  sprite_popup.connect('id_pressed', self, "_on_sprite_selected")

