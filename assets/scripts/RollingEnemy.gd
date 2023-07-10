extends RigidBody3D

var player = null
const SPEED = 4.0




@export var player_path : NodePath
@onready var nav_agent =  $NavigationAgent3D

func check_veering(b):
	var veerage = self.linear_velocity.dot(-b.basis.z)
	if veerage < 0:
		self.angular_velocity = b.basis.x * -4
	
func generic_direction_stab(rvel):
	var p1 = self.global_transform.origin + Vector3(0,1,0)
	var p2 = self.global_transform.origin - Vector3(0,1,0) + rvel.basis.z
	var midpoint = p1.lerp(p2,0.5)
	$cone.global_transform.origin = midpoint
	$cone.global_transform.basis = self.transform.looking_at(p2).basis
	$cone.global_transform = $cone.global_transform.rotated_local(rvel.basis.y,90)
	


var stunned = false
func stun():
	stunned = true



func _ready():
	player = get_node(player_path)


func _process(_delta):
	if not player:
		pass
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	var rvel = global_transform.looking_at(next_nav_point,Vector3(0,1,0))

	self.apply_torque_impulse(rvel.basis.x * -0.02)
	if  Time.get_ticks_msec() % 300 < 80 :
		generic_direction_stab(rvel)
	check_veering(rvel)
	#self.apply_torque(rvel*2)
