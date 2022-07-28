extends Actor

const IA_DECISION_INTERVAL = 16.0

var ia_clock = 15.0

func take_decision():
  ia_clock -= IA_DECISION_INTERVAL
  if !!target_position:
    print ('already doing something')
    return
  go_to_nearest_resource('herb')
  
func _process(delta):
  ia_clock += delta
  if ia_clock >= IA_DECISION_INTERVAL:
    take_decision()


