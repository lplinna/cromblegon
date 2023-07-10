extends RigidBody3D

var player = null
var SPEED = 4
var npoint = Vector3()

@export var player_path : NodePath
@onready var nav_agent =  $NavigationAgent3D
var feet = []
var heels = []
var moving = []
var foot_step = 0
var bob_aggro = 0.2
var step_speed = 0.2
var step_distance = 1.2
var ANGRY = false


#Stun response - gets faster and angrier.
var stunned = false
func stun():
	stunned = true
	step_speed = 0.07
	step_distance = 0.5
	await get_tree().create_timer(0.8).timeout
	stunned = false
	step_speed = 0.15
	step_distance = 1.2
	SPEED = 8
	ANGRY = true
	bob_aggro = 0.4
	
	
	
	
func state_machine():
	await get_tree().create_timer(randi() % 4).timeout
	if ANGRY:
		SPEED = randi()%6 + 8
	else:
		SPEED = randi()%6 + 4
	print("bruh")
	state_machine()
	

func _ready():
	randomize()
	player = get_node(player_path)
	feet = [$Foot1,$Foot2,$Foot3,$Foot4]
	heels = [$Head/Heel1,$Head/Heel2,$Head/Heel3,$Head/Heel4]
	moving = [false,false,false,false]
	
	set_freeze_enabled(true)
	await get_tree().create_timer(randf_range(0,6.0)).timeout
	set_freeze_enabled(false)
	
	state_machine()


func update_feet():
	for i in range(0,len(heels)):
		var foot  = feet[i]
		var heel = heels[i]
		var vd = foot.global_position.distance_to(heel.global_position)
		if vd > step_distance and foot_step == i:
			$FootCast.global_position = heel.global_position
			$FootCast.force_raycast_update()
			if $FootCast.is_colliding():
				var n1 = $FootCast.get_collision_normal()
				var floorpoint = $FootCast.get_collision_point()
				
				#h is final destination
				var h = $Head.transform
				h.basis.y = n1
				h = h.orthonormalized()
				h.origin = floorpoint + (n1 * 0.2)
				
				#h2 is intermediary position
				var h2 = $Head.global_transform
				h2.origin += Vector3(0,-0.8,0)
				
				if moving[i] == false:
					#Step1 makes the feet walk
					moving[i] = true
					var step1 = get_tree().create_tween()
					step1.tween_property(foot,"transform",h2,step_speed)
					step1.tween_property(foot,"transform",h,step_speed)
					
					var step1end = func():
						moving[i] = false
						step1.kill()
						foot_step = (foot_step + 1) % 4	
					step1.tween_callback(step1end)
					
					#Step2 makes the head bob
					var step2 = get_tree().create_tween()
					var h3 = $Head.global_transform.interpolate_with(foot.global_transform,bob_aggro)
					step2.tween_property($Head/HeadMesh,"global_position",h3.origin,0.2)
					step2.tween_property($Head/HeadMesh,"global_position",$Head.global_transform.origin,0.2)
		


func _integrate_forces(state):
	nav_agent.set_target_position(player.global_transform.origin)
	npoint = nav_agent.get_next_path_position()
	if not stunned:
		state.linear_velocity = (npoint - global_transform.origin).normalized() * SPEED
		$Head.look_at(player.global_transform.origin + Vector3(0,1,0))
	
	
	update_feet()
	
