extends Node

export (PackedScene) var Ball

var balls = 0

func _ready():
	$Music.play()

func _input(event):
	if event.is_action_pressed("click"):
		$Drop.play()
		balls += 1
		var new_ball = Ball.instance()
		new_ball.position = get_viewport().get_mouse_position()
		add_child(new_ball)
		$HUD.score = balls
