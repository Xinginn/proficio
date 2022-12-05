extends Panel

onready var race_choice_label= $RaceChoiceLabel
onready var race_menu: MenuButton = $RaceChoiceLabel/MenuButton
onready var race_popup = race_menu.get_popup()
onready var sprite_menu: MenuButton = $ApparenceLabel/MenuButton
onready var sprite_popup = sprite_menu.get_popup()
onready var description_text = $DescriptionText
onready var stats_text = $StatsText
onready var animated_sprite = $ApparenceLabel/AnimatedSprite
onready var name_input = $Label/NameInput

var character_name = ""
var selected_race = null setget _set_race
var selected_sprite_name = null setget _set_sprite
var sprites = []

signal character_created(_name)

func _set_race(value) -> void:
	if value != selected_race:
		selected_race = value 
		# TODO load des images pour la race

func _set_sprite(value) -> void:
	selected_sprite_name = value
	animated_sprite.frames = load('res://tres/spriteframes/actors/%s.tres' % value)
	animated_sprite.animation = "walk_down"
	animated_sprite.frame = 0
	animated_sprite.playing = true

func get_race_sprites() -> Array:
	var sprite_names = []
	var files = Utils.get_files_in_directory('res://tres/spriteframes/actors')
	for file in files:
		if file.begins_with(Data.races[selected_race]["name"]):
			sprite_names.append(file.replace('.tres', ''))
	return sprite_names
	
func _on_name_text_changed(new_text):
	character_name = new_text

func _on_race_selected(id):
	self.selected_race = id
	var race = Data.races[id]
	race_choice_label.text = "Race: %s" % race["label"]
	description_text.text = race["description"]
	stats_text.text = race["stats_text"]
	sprite_menu.disabled = false
	var sprite_popup = sprite_menu.get_popup()
	sprite_popup.clear()
	sprites = get_race_sprites()
	for sprite in sprites:
		sprite_popup.add_item(sprite)
	self.selected_sprite_name = sprites[0]

func _on_sprite_selected(id):
	self.selected_sprite_name = sprites[id]
	
func _on_confirm_pressed():
	if character_name == "":
		return
	if selected_race == null: 
		return
	var new_chara = load('res://entities/actor/actor.tscn').instance()
	new_chara._name = character_name
	new_chara.race = selected_race
	add_child(new_chara)
	new_chara.sprite_path = selected_sprite_name
	match selected_race:
		1:
			new_chara.max_health = 18
			new_chara.max_stamina = 18
			new_chara.max_mana = 9
		2:
			new_chara.max_health = 12
			new_chara.max_stamina = 15
			new_chara.max_mana = 18
	SaveManager.save_actor_data(new_chara)
	emit_signal('character_created', character_name)
	
func _ready():
	for race in Data.races:
		race_popup.add_item(race["label"])
	race_popup.connect('id_pressed', self, "_on_race_selected")
	sprite_popup.connect('id_pressed', self, "_on_sprite_selected")
	sprite_menu.disabled = true
