extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered",PollArea)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func PollArea(body):
	if "pickups" in body.get_groups():
		print("Pickup found")
		body.get_parent().get_pickedup(self)
	pass
