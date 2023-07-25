extends Control
var max_health = 30
var current_health = 30;
var p
var oldbar_health = 30;
var gostack = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	p = $NinePatchRect.get_end() - $NinePatchRect.get_begin()
	$Rect1.set_size(Vector2(p.x,p.y))
	$Rect2.set_size(Vector2(0,p.y))
	$Rect2.offset_left = p.x
	$Rect2.offset_right = p.x
	pass # Replace with function body.


func damage(amt):
	current_health -= amt
	var d = current_health/max_health
	$Rect1.set_size(Vector2(p.x*d,p.y))


func set_health(h):
	if h < current_health:
		TweenRect2(h)
	current_health = h	


func shrink_yellow():
	var tween2 = get_tree().create_tween()
	tween2.tween_property($Rect2,"offset_right",$Rect2.offset_left,0.6).set_trans(Tween.TRANS_CIRC)
	tween2.parallel().tween_property($Rect1,"offset_right",$Rect2.offset_left,0.6).set_trans(Tween.TRANS_CIRC)
	oldbar_health = current_health


func TweenRect2(h):
	var d0 = float(oldbar_health)/float(max_health)
	var d1 = float(h)/float(max_health)
	var tween1 = get_tree().create_tween()
	tween1.tween_property($Rect2,"offset_left",d1*p.x,0.6).set_trans(Tween.TRANS_CIRC)
	tween1.parallel().tween_property($Rect2,"offset_right",p.x * d0,0.6).set_trans(Tween.TRANS_CIRC)
	gostack += 1
	await tween1.finished
	gostack -= 1
	if(gostack == 0):
		shrink_yellow()
	


func _input(event):
	if event.is_action_pressed("movement_forward"):
		set_health(current_health-5)
	if event.is_action_pressed("movement_left"):
		set_health(current_health-1)
