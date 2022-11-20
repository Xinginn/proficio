extends Actor
class_name Player


func _on_hotkeys_switch_requested(index_a: int, index_b: int) -> void:
  var tmp = techs[index_a]
  techs[index_a] = techs[index_b]
  techs[index_b] = tmp
  emit_signal("tech_list_changed", techs)
  tmp = cooldowns[index_a]
  cooldowns[index_a] = cooldowns[index_b]
  cooldowns[index_b] = tmp
  emit_signal("cooldowns_changed", cooldowns)
  for tech in techs:
    print(tech._name)

func _physics_process(_delta):
  # movement clavier pour player
  var key_target: Vector2 = Vector2(0.0, 0.0)
  if Input.is_action_pressed("ui_left"):
    key_target.x -= 10.0
  if Input.is_action_pressed("ui_right"):
    key_target.x += 10.0
  if Input.is_action_pressed("ui_up"):
    key_target.y -= 10.0
  if Input.is_action_pressed("ui_down"):
    key_target.y += 10.0
  if key_target != Vector2(0.0, 0.0):
    move_to(global_position + key_target)
  
func _unhandled_input(event):
  if is_dead:
    return
  # gestion attack
  var action_number = null
  if event is InputEventMouseButton:
    if event.button_index == BUTTON_RIGHT and event.pressed:
      action_number = 0
      if can_afford_skill(techs[0].cost):  # gestion temporaire couts
        if cooldowns[0] == 0.0: # TODO gestion cooldonw
          launch_tech(0, get_global_mouse_position())
  if event is InputEventKey:
    if Input.is_action_just_pressed("action_1"):
      action_number = 1
    if Input.is_action_just_pressed("action_2"):
      action_number = 2
    if Input.is_action_just_pressed("action_3"):
      action_number = 3
    if Input.is_action_just_pressed("action_4"):
      action_number = 4
    if Input.is_action_just_pressed("action_5"):
      action_number = 5
  if action_number == null:
    return
  if !techs[action_number]:
    return
  if can_afford_skill(techs[action_number].cost) and cooldowns[action_number] == 0.0:
    launch_tech(action_number, get_global_mouse_position())
