extends RigidBody3D

var destination := Vector3()
const SPEED = 5

func _ready():
	set_destination(Vector3(0,0,0))
	


func set_destination(new_dest: Vector3):
	destination = new_dest;
	$NavigationAgent3D.set_target_position(destination)
	
func _integrate_forces(_state):
	if $NavigationAgent3D.is_target_reachable():
		var target = $NavigationAgent3D.get_next_path_position()
		var vel =  global_transform.origin.direction_to(target).normalized() * SPEED
		$NavigationAgent3D.set_velocity(vel)
	else:
		self.set_axis_velocity(Vector3.ZERO)
		print("huh")
	


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	self.set_axis_velocity(safe_velocity)
	pass # Replace with function body.
