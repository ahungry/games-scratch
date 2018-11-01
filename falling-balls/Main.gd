extends Node

export (PackedScene) var Ball

var balls = 0
var rot = 0

func _ready():
	$Music.play()

func _input(event):
	if event.is_action_pressed("click"):
		# $Drop.play()
		balls += 1
		var new_ball = Ball.instance()
		new_ball.position = get_viewport().get_mouse_position()
		add_child(new_ball)
		$HUD.score = balls

func _process(delta):
	rot += 0.01
	$WallContainer/Wall8.rotation = rot / 8
	$WallContainer/Wall7.rotation = rot / 7
	$WallContainer/Wall6.rotation = rot / 6
	$WallContainer/Wall5.rotation = rot / 5
	$WallContainer/Wall4.rotation = rot / 4
	$WallContainer/Wall3.rotation = rot / 3
	$WallContainer/Wall2.rotation = rot / 2
	$WallContainer/Wall1.rotation = rot / 1
