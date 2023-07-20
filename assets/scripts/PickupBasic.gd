extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation.y += 5*delta;
	pass


func get_pickedup(player):
	var t = get_tree().create_tween();
	t.tween_property(self,"position",player.location,1)
