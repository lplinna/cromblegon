extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var mouse_sens = 0.003
var gravdir = Vector3(0,1,0)


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")



func _input(event):
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







func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
