extends Area2D

const N = 0x1
const E = 0x2
const S = 0x4
const W = 0x8

var animations = {N: 'n',
				  S: 's',
				  E: 'e',
				  W: 'w'}
var moves = {N: Vector2(0, -1),
			 S: Vector2(0, 1),
			 E: Vector2(1, 0),
			 W: Vector2(-1, 0)}

var map = null
var map_pos = Vector2()
var speed = 1
var moving = false

func can_move(dir):
	var t = map.get_cellv(map_pos)
	if t & dir:
		return false
	else:
		return true

func _input(event):
	if moving:
		return
	if event.is_action_pressed('ui_up'):
		move(N)
	if event.is_action_pressed('ui_down'):
		move(S)
	if event.is_action_pressed('ui_right'):
		move(E)
	if event.is_action_pressed('ui_left'):
		move(W)

func _ready():
	#var http = HTTPRequest.instance()
	var http = HTTPRequest.new()
	add_child(http)
	connect("request_completed", http, "_on_HTTPRequest_request_completed", [])
	http.request('http://127.0.0.1:12345/')
	printt("I am sending the request by now...")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	printt("Got something back...")
	var json = JSON.parse(body.get_string_from_utf8())
	printt(json.result)
	show_message("Your coords were: " + json.result.x + " and " + json.result.y)

func move(dir):
	if not can_move(dir):
		return
	moving = true
	$AnimatedSprite.play(animations[dir])
	map_pos += moves[dir]
	# Go to an absolute position
	# map_pos = Vector2(5, 5)
	if map.get_cellv(map_pos) == -1:
		get_parent().generate_tile(map_pos)
	var destination = map.map_to_world(map_pos) + Vector2(0, 20)
	$Tween.interpolate_property(self, 'position', position, destination, speed,
								Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	printt('Debug info for truck')
	printt(get_position().x)
	printt(get_position().y)
	printt(destination)
	printt(map_pos)
	printt(map_pos.x)
	printt(map_pos.y)

func _on_Tween_tween_completed(object, key):
	moving = false
