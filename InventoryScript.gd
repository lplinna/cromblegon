extends Node3D

var CameraPath

@export var PipeW:PackedScene
@export var TeapotW:PackedScene

var equipped = null

func _ready():
	CameraPath = self.get_parent().get_node("Camera3D")

func _input(event):
	if event.is_action_pressed("1"):
		if(equipped != null):
			equipped.queue_free()
		var PW = PipeW.instantiate()
		CameraPath.add_child(PW)
		equipped = PW

	if event.is_action_pressed("2"):
		if(equipped != null):
			equipped.queue_free()
		var TW = TeapotW.instantiate()
		CameraPath.add_child(TW)
		equipped = TW

