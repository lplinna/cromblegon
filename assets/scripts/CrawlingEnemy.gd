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



func _ready():
	player = get_node(player_path)
	feet = [$Foot1,$Foot2,$Foot3,$Foot4]
	heels = [$Head/Heel1,$Head/Heel2,$Head/Heel3,$Head/Heel4]
	moving = [false,false,false,false]
	
	set_freeze_enabled(true)
	await get_tree().create_timer(randi() % 4).timeout
	set_freeze_enabled(false)
	


func update_feet():
	for i in range(0,len(heels)):
		var foot  = feet[i]
		var heel = heels[i]
		var vd = foot.global_position.distance_to(heel.global_position)
		if vd > 1.2 and foot_step == i:
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
					step1.tween_property(foot,"transform",h2,0.2)
					step1.tween_property(foot,"transform",h,0.2)
					
					var step1end = func():
						moving[i] = false
						step1.kill()
						foot_step = (foot_step + 1) % 4	
					step1.tween_callback(step1end)
					
					#Step2 makes the head bob
					var step2 = get_tree().create_tween()
					var h3 = $Head.global_transform.interpolate_with(foot.global_transform,0.2)
					step2.tween_property($Head/HeadMesh,"global_position",h3.origin,0.2)
					step2.tween_property($Head/HeadMesh,"global_position",$Head.global_transform.origin,0.2)
		


func _integrate_forces(state):
	nav_agent.set_target_position(player.global_transform.origin)
	npoint = nav_agent.get_next_path_position()
	state.linear_velocity = (npoint - global_transform.origin).normalized() * SPEED
	$Head.look_at(player.global_transform.origin + Vector3(0,1,0))
	
	
	update_feet()
	
