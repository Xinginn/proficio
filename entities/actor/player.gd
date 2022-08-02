extends Actor

func _physics_process(delta):
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
      var attack_direction = Vector2(get_global_mouse_position() - global_position).normalized()
      launch_attack("attack", attack_direction)
