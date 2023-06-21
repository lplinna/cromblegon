extends RigidBody3D

@onready var player = get_node("../Player")

func _ready():
	leap_motion()
	apply_force(Vector3(0,-30,0))
	pass

func leap_motion():
	await get_tree().create_timer(0.05).timeout
	var vel =  global_transform.origin.direction_to(player.global_transform.origin).normalized()
	vel.y = 0;
	vel = vel.normalized();
	apply_central_impulse(vel*3)

		
	
	leap_motion()
	


	

