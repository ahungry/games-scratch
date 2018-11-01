extends Node

export (PackedScene) var Ball

var balls = 0
var rot = 0
var rot_inc = 0.001
var score = 0
var words = ["A", "B", "C", "D", "E", "F", "G", "H", "I",
"J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U",
"V", "W", "X", "Y", "Z"]
# TODO Set this randomly
var avoid = ["A", "B", "C", "D", "E"]
var level = 4

func set_avoids():
	avoid = []
	for i in range(0, level):
		var letter = words[randi() % words.size()]
		avoid.push_front(letter)

func _ready():
	set_avoids()
	randomize()
	$Music.play()
	$HUD/Avoid.text = str(avoid)

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
	var good = 0
	var bad = 0
	var balls = get_tree().get_nodes_in_group("balls") #.size()
	for ball in balls:
		var matched = false
		var letter = ball.get_node("Letter")

		for a in avoid:
			if a == letter.text:
				matched = true

		if matched == false:
			good += 1
		else:
			bad += 1

	score += good - bad
	$HUD/Score.text = str(score)
	$HUD/Good.text = str(good)
	$HUD/Bad.text = str(bad)
