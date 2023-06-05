extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


var dir = Vector3()
const GRAVITY = -24.8
var vel = Vector3()
var gravdir = Vector3(0,1,0)
const MAX_SPEED = 20
const JUMP_SPEED = 14
const MAX_SLOPE_ANGLE = 40
var XMULTIPLIER = 6.0
var ZMULTIPLIER = 6.0
var YMULTIPLIER = 3.0

#Hand offsets
var RH_offset = Vector3()
var LH_offset = Vector3()


func reorient():
	var n = $Camera3D.transform.origin + ($Camera3D.transform.basis.z.normalized() * 30)
	$Camera3D.transform = $Camera3D.transform.looking_at(-n,gravdir.normalized())
	
	


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Debugline2.glyph_here(Transform(self.transform.basis,Vector3.ZERO),1939)
	reorient()
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta):
	#Debugline2.pluck_glyph()
	#Debugline2.glyph_here(Transform($Camera.transform.basis,transform.origin - ($Camera.transform.basis.z*3) - ($Camera.transform.basis.y * 0)),int(10*self.translation.z),0,Color.green,0.2)
	process_movement_2(delta)
	process_input_2(delta)


func process_input_2(_delta):

	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



	var input_movement_vector = Vector2()
	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x += 1



	#input_movement_vector = input_movement_vector.normalized()


	dir.x = (dir.x + input_movement_vector.x)/1.2
	dir.z = (-input_movement_vector.y + dir.z)/1.2



	if is_on_floor():
		dir.y = 0
		if Input.is_action_pressed("movement_jump"):
			#dir += Vector3(gravdir.x * JUMP_SPEED,gravdir.y * JUMP_SPEED, gravdir.z * JUMP_SPEED)
			dir.y = JUMP_SPEED/1.5


func process_movement_2(delta):
	var g = $Camera3D.get_global_transform()
	g.basis.z = g.basis.x.cross(gravdir.normalized())
	g.basis.y = gravdir.normalized()
	vel = (g.basis.z * dir.z*ZMULTIPLIER) + (g.basis.x * dir.x*XMULTIPLIER) + (g.basis.y * dir.y * YMULTIPLIER)
	dir.y += GRAVITY * delta
	velocity = vel
	move_and_slide()




func hold_style_3(holder, identity = self):
	var gun = identity
	var camera = holder.get_node("Camera3D")
	gun.global_transform = camera.global_transform.translated((camera.transform.basis.z*-3) + (camera.transform.basis.x * 0.5))



var mouse_sens = 0.003
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
		$Camera3D.position = $CamRoot.position
		$SpotLight3D.transform = $Camera3D.transform
		hold_style_3(self,$MeshInstance3D2)
		





