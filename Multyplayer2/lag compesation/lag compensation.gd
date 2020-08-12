extends KinematicBody2D

var motion = Vector2(0,0)
var goal = Vector2(0,0)
var goal_aux = Vector2(0,0)
var speed = 500.0
var positions = [Vector2(0,0),Vector2(0,0)]
var ints = 0
var deadzone = 10
var diff = Vector2(0,0)
var speed_array = []
var ping = 0

func _physics_process(delta):
	ping = $Timer2.wait_time * 500
	if get_global_position().distance_to(goal) > ping:
		motion = (goal - get_global_position()).normalized() * speed
	if get_global_position().distance_to(goal) > deadzone:
		move_and_slide(motion)

func _on_Timer_timeout():
	goal_aux = get_parent().get_node("AnimatedSprite").position
	pass # Replace with function body.

func _on_Timer2_timeout():
	goal = goal_aux
	pass # Replace with function body.
