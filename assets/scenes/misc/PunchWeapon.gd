extends Node3D

var swinging = false

func _ready():
	$PunchRoot/CharacterBody3D.visible=false

func use():	
	if swinging:
		return
	$PunchRoot/CharacterBody3D.visible = true
	var t = $PunchRoot/CharacterBody3D
	var o_t = t.transform
	var tween = get_tree().create_tween()
	tween.tween_property(t,"transform",$PunchRoot/PunchEnd.transform,0.2/2).set_ease(Tween.EASE_OUT);
	tween.tween_property(t,"transform",$PunchRoot/PunchStart.transform,0.2);
	swinging = true
	await tween.finished
	swinging = false
	$PunchRoot/CharacterBody3D.visible = false


	
	
func _input(event):
	if event.is_action_pressed("Punch"):
		use()
