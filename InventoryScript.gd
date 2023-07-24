extends Node3D

var CameraPath
var PlayerPath

@export var PipeW:PackedScene
@export var TeapotW:PackedScene

var equipped = null

func _ready():
	CameraPath = self.get_parent().get_node("Camera3D")
	PlayerPath = self.get_parent()
	reset_actions()
	

func reset_actions():
	PlayerPath.weapon_usage = func(): print("Nothing to use")
	PlayerPath.weapon_reload = func(): print("Nothing to reload")

func _input(event):
	if event.is_action_pressed("1"):
		if(equipped != null):
			equipped.queue_free()
			reset_actions()
		var PW = PipeW.instantiate()
		CameraPath.add_child(PW)
		equipped = PW
		PlayerPath.weapon_usage = func(): PW.use() # Assign left click activity

	if event.is_action_pressed("2"):
		if(equipped != null):
			equipped.queue_free()
			reset_actions()
		var TW = TeapotW.instantiate()
		CameraPath.add_child(TW)
		equipped = TW
		PlayerPath.weapon_usage = func(): TW.fire() #Assign left click activity
		PlayerPath.weapon_reload = func(): TW.reload() #Assign reload activity

