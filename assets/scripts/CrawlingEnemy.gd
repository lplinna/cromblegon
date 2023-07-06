extends CharacterBody3D

var player = null
const SPEED = 4.0
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

func set_done():
	moving[0] = false


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
					moving[i] = true
					var step1 = get_tree().create_tween()
					step1.tween_property(foot,"transform",h2,0.2/2)
					
					var step2end = func():
						moving[i] = false
						step1.kill()
						foot_step = (foot_step + 1) % 4	
						
					var step1end = func():
						var step2 = get_tree().create_tween()
						step2.tween_property(foot,"transform",h,0.2/2)
						step2.tween_callback(step2end)
						

					step1.tween_callback(step1end)
		


func _physics_process(delta):
	nav_agent.set_target_position(player.global_transform.origin)
	npoint = nav_agent.get_next_path_position()
	velocity = (npoint - global_transform.origin).normalized() * SPEED
	$Head.look_at(player.global_transform.origin)
	
	move_and_slide()

	
	update_feet()
	
