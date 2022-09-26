extends Actor
class_name Player


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
  # gestion attack
  if event is InputEventMouseButton:
    if event.button_index == BUTTON_RIGHT and event.pressed:
      if can_afford_skill(techs[0].cost):  # gestion temporaire couts
        if cooldowns[0] == 0.0: # TODO gestion cooldonw
          launch_tech(0, get_global_mouse_position())
  if event is InputEventKey:
    if Input.is_action_just_pressed("action_1"):
      if can_afford_skill(techs[1].cost):  # gestion temporaire couts
        if cooldowns[1] == 0.0: # TODO gestion cooldonw
          launch_tech(1, get_global_mouse_position())
    if Input.is_action_just_pressed("action_2"):
      if can_afford_skill(techs[2].cost):  # gestion temporaire couts
        if cooldowns[2] == 0.0: # TODO gestion cooldonw
          launch_tech(2, get_global_mouse_position())
    if Input.is_action_just_pressed("action_3"):
      if can_afford_skill(techs[2].cost):  # gestion temporaire couts
        if cooldowns[3] == 0.0: # TODO gestion cooldonw
          launch_tech(3, get_global_mouse_position())

