extends RigidBody3D

var gravdir = Vector3.UP
var floor_dir = Vector3.UP
var on_floor = false
var jumping = false
const gravity_multiplier_ground = 1.0
const gravity_multiplier_air = 4.0
var cur_g_mul = 1.0
var floorpoint = Vector3()


var weapon_usage: Callable
var weapon_reload: Callable

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

func know_floor_2():
		$Feet.force_raycast_update()
		if $Feet.is_colliding():
			var n1 = $Feet.get_collision_normal()
			floorpoint = $Feet.get_collision_point()
			if n1.angle_to(gravdir) < 1.2:
				floor_dir = n1
				on_floor = true
				if jumping:
					jumping = false
		else:
			on_floor = false



func _integrate_forces(state):
	var input_movement_vector = Vector2()
	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x += 1
	
	know_floor_2()
	
	if(on_floor and input_movement_vector == Vector2.ZERO):
		state.linear_velocity = Vector3.ZERO

	var g= $Camera3D.get_global_transform()
	g.basis.z = g.basis.x.cross(floor_dir)
	g.basis.y = floor_dir.normalized()
	var t = (input_movement_vector.x * g.basis.x) + (input_movement_vector.y * -g.basis.z)
	

	#Artificial dampening
	var damp_b = state.linear_velocity.project(gravdir)
	var damp_a = state.linear_velocity - damp_b
	var z = damp_a.length() - 12
	if z > 0:
		apply_force(-z * t * 8)	
	apply_force(t*75)
	
	
	if jumping:
		apply_central_impulse(gravdir * -1.2/1.5)
	
	if Input.is_action_just_pressed("movement_jump") and on_floor and not jumping:
		apply_central_impulse(gravdir * 8)
		jumping = true
	
	#print(on_floor)
	




func PUNCH():
	$Camera3D/PhysicsRaycast.force_raycast_update();
	if $Camera3D/PhysicsRaycast.is_colliding():
		var collider = $Camera3D/PhysicsRaycast.get_collider()
		var n2 = $Camera3D/PhysicsRaycast.global_transform.basis.z.project(gravdir)
		var n1 = $Camera3D/PhysicsRaycast.global_transform.basis.z - n2
		if "Enemy" in collider.get_groups(): #Untested
			collider.apply_central_impulse(n1 * -25)
			#collider.apply_central_impulse(Vector3.UP * 6)
			collider.stun()
		






var mouse_sens = 0.003
func _input(event):
	
	if event.is_action_pressed("Interact"): #Replace with better validation system.
		PUNCH()
		
	if event.is_action_pressed("Reload"):
		weapon_reload.call()
	
	
	if event is InputEventMouseMotion:
		var g = $Camera3D.transform
		var k = g.rotated(gravdir.normalized(),-event.relative.x*mouse_sens)
		k.basis.x = k.basis.x.normalized()
		k = k.rotated(k.basis.x,-event.relative.y*mouse_sens)

		var j = k.basis.z.angle_to(gravdir)
		var l = k.basis.y.angle_to(gravdir)


		if((l-1.5)>0):
			k = k.rotated(k.basis.x,event.relative.y*mouse_sens)
#
		if((j-1.5) >= 1.5):
			k = k.rotated(k.basis.x,event.relative.y*mouse_sens)


		$Camera3D.transform = k
		$Camera3D.position = $CamRoot.position
		#$SpotLight3D.transform = $Camera3D.transform
		#hold_style_3(self,$MeshInstance3D2)


func _on_pickup_area_body_entered(body):
	pass # Replace with function body.
