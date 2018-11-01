extends Node

export (PackedScene) var Ball

var balls = 0
var rot = 0
var rot_inc = 0.001
var score = 0

func _ready():
	randomize()
	$Music.play()

func _input(event):
	if event.is_action_pressed("click"):
		# $Drop.play()
		balls += 1
		var new_ball = Ball.instance()
		new_ball.position = get_viewport().get_mouse_position()
		add_child(new_ball)
		#$HUD.score = balls

func _process(delta):
	if rot > 1:
		rot_inc = -0.001

	if rot < 0:
		rot_inc = 0.001

	rot += rot_inc

	$WallContainer/Wall8.rotation = rot * 8
	$WallContainer/Wall7.rotation = rot * 7
	$WallContainer/Wall6.rotation = rot * 6
	$WallContainer/Wall5.rotation = rot * 5
	$WallContainer/Wall4.rotation = rot * 4
	$WallContainer/Wall3.rotation = rot * 3
	$WallContainer/Wall2.rotation = rot * 2
	$WallContainer/Wall1.rotation = rot * 1
	$BG.color = Color (rot, rot * 2, rot * 3, 0.4)


func _on_Timer_timeout():
	var balls = get_tree().get_nodes_in_group("balls").size()
	var bad_balls = get_tree().get_nodes_in_group("bad_balls").size()
	score += balls
	$HUD/Score.text = str(score)
	$HUD/Good.text = str(balls)
	$HUD/Bad.text = str(bad_balls)
