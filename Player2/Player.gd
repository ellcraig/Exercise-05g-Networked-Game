extends KinematicBody

var max_speed = 5
var speed = 5
var velocity = Vector3()
var direction = Vector3()
var current_speed = velocity.length()


remote func _set_position(pos):
	global_transform.origin = pos

func _physics_process(_delta):
	direction = get_input()
	if direction != Vector3():
		if is_network_master():
			move_and_slide(direction * speed, Vector3.UP)
			$AnimationTree.set("parameters/Idle_Walk/blend_amount", speed) 
		rpc_unreliable("_set_position", global_transform.origin)


func get_input():
	var to_return = Vector3()
	if Input.is_action_pressed("left"):
		to_return -= transform.basis.x
	elif Input.is_action_pressed("right"):
		to_return += transform.basis.x
	if Input.is_action_pressed("forward"):
		to_return -= transform.basis.z
	elif Input.is_action_pressed("back"):
		to_return += transform.basis.z
	to_return = to_return.normalized()
	return to_return


