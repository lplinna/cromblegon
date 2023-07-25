extends Node3D

var swinging = false
var swingtween = null

func use():
	if swinging:
		return
	swingtween = get_tree().create_tween();
	print("running")
	swinging = true
	
	
	swingtween.tween_property($PipeRoot/PipeRoot2,"transform",$PipeRoot/pullback.transform,0.2)
	swingtween.tween_property($PipeRoot/PipeRoot2,"transform",$PipeRoot/swing.transform,0.2)
	swingtween.tween_property($PipeRoot/PipeRoot2,"transform",$PipeRoot/origin.transform,0.2)
	await swingtween.finished
	swinging = false
	

func recoil():
	swingtween.kill()
	swingtween = get_tree().create_tween();
	swingtween.tween_property($PipeRoot/PipeRoot2,"transform",$PipeRoot/pullback.transform,0.1)
	swingtween.tween_property($PipeRoot/PipeRoot2,"transform",$PipeRoot/origin.transform,0.1)
	await swingtween.finished
	swinging = false
	
	
	
func _input(event):
	if event.is_action_pressed("Interact"):
		use()


func _on_character_body_3d_body_entered(body):
	if(swinging):
		$PipeRoot/CLANG.play()
		if "Enemy" in body.get_groups():
			body.apply_central_impulse($PipeRoot.global_transform.basis.z*-30)
		else:
			if body is RigidBody3D:
				body.apply_central_impulse($PipeRoot.global_transform.basis.z*-12)
		recoil()
	print(body)
	pass # Replace with function body.
