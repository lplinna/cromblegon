extends Node3D

var swinging = false
var swingtween = null

func use():
	if swinging:
		return
	$PipeRoot.rotation.x = 0
	swingtween = get_tree().create_tween();
	print("running")
	swinging = true
	swingtween.tween_property($PipeRoot,"rotation:x",-PI/2,0.2)
	swingtween.tween_property($PipeRoot,"rotation:x",0,0.2)
	await swingtween.finished
	swinging = false
	

func recoil():
	swingtween.kill()
	swingtween = get_tree().create_tween();
	swingtween.tween_property($PipeRoot,"rotation:x",0,0.2)
	await swingtween.finished
	swinging = false


func _on_character_body_3d_body_entered(body):
	if(swinging):
		$PipeRoot/CLANG.play()
		if "Enemy" in body.get_groups():
			body.apply_central_impulse($PipeRoot.global_transform.basis.y*30)
		else:
			if body is RigidBody3D:
				body.apply_central_impulse($PipeRoot.global_transform.basis.y*12)
		recoil()
	print(body)
	pass # Replace with function body.
