extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reload():
	var t = $TeapotRoot/shtumbusteapot/AnimationTree
	t.active = true
	t["parameters/TimeSeek/seek_request"] = 0.0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
