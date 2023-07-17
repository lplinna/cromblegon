extends Control
var max_health = 30
var current_health = 30;
var p



# Called when the node enters the scene tree for the first time.
func _ready():
	p = $NinePatchRect.get_end() - $NinePatchRect.get_begin()
	$Rect1.set_size(Vector2(p.x,p.y))
	pass # Replace with function body.


func damage(amt):
	current_health -= amt
	var d = current_health/max_health
	$Rect1.set_size(Vector2(p.x*d,p.y))


func set_health(h):
	if h < current_health:
		TweenRect2(h)
	current_health = h

func TweenRect2(h):
	var d0 = float(current_health)/float(max_health)
	var d1 = float(h)/float(max_health)
	$Rect2.set_size(Vector2(3,p.y))
	$Rect2.set_position(Vector2(d0*p.x,0))
	var tween1 = get_tree().create_tween()
	# Part 1 - yellow part
	tween1.tween_property($Rect2,"position",Vector2(d1*p.x,0),0.6).set_trans(Tween.TRANS_EXPO)
	tween1.parallel().tween_property($Rect2,"size",Vector2((d0*p.x) - (d1*p.x),p.y),0.6).set_trans(Tween.TRANS_EXPO)
	# Part 2 - whole healthbar shrinks
	tween1.tween_property($Rect2,"size",Vector2(0,p.y),0.6).set_trans(Tween.TRANS_EXPO)
	tween1.parallel().tween_property($Rect1,"size",Vector2(d1*p.x,p.y),0.6).set_trans(Tween.TRANS_EXPO)

func _input(event):
	if event.is_action_pressed("movement_forward"):
		set_health(current_health-5)
