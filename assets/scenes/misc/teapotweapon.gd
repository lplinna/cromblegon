extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reload():
	var t = $TeapotRoot/shtumbusteapot/AnimationTree
	t.active = true
	t["parameters/TimeSeek/seek_request"] = 0.0
	
func fire():
	var t = $TeapotRoot/shtumbusteapot
	var tween = get_tree().create_tween()
	var o_t = t.transform
	tween.tween_property(t,"transform",$TeapotRoot/Fire1.transform,0.08);
	tween.tween_property(t,"transform",o_t,0.08);


func _input(event):
	if event.is_action_pressed("Interact"):
		fire()
	if event.is_action_pressed("Reload"):
		reload()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
