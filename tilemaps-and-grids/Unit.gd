extends Area2D

const N = 0x1
const E = 0x2
const S = 0x4
const W = 0x8

const HEAD = 0x1

var animations = {N: 'n',
				  S: 's',
				  E: 'e',
				  W: 'w'}
var moves = {N: Vector2(0, -1),
			 S: Vector2(0, 1),
			 E: Vector2(1, 0),
			 W: Vector2(-1, 0)}
var gear = []
var map = null
var map_pos = Vector2()
var speed = 1
var moving = false

var dest_x = 0
var dest_y = 0

var flip_h = false
var anim = 'knight'
var back = false

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
		flip_h = false
		#modulate = Color(0.1, 0.1, 0.1)
		anim = 'knight-back'
		back = true
	if event.is_action_pressed('ui_down'):
		move(S)
		flip_h = false
		#modulate = Color(1, 1, 1)
		anim = 'knight'
		back = false
	if event.is_action_pressed('ui_right'):
		move(E)
		flip_h = true
		#modulate = Color(1, 1, 1)
		anim = 'knight'
		back = false
	if event.is_action_pressed('ui_left'):
		move(W)
		flip_h = true
		#modulate = Color(0.1, 0.1, 0.1)
		anim = 'knight-back'
		back = true

func boot(stubs):
	# Loop over and add the gear
	#var stubs = [{'back': '32b-red-scarf', 'default': '32-red-scarf-front'}]
	for stub in stubs:
		var res1 = load('res://assets/IsoUnits/' + stub.default.png + '-0.png')
		var res2 = load('res://assets/IsoUnits/' + stub.default.png + '-1.png')
		var res3 = load('res://assets/IsoUnits/' + stub.back.png + '-0.png')
		var res4 = load('res://assets/IsoUnits/' + stub.back.png + '-1.png')
		var f = SpriteFrames.new()
		f.animations = [
		{'frames': [res3, res4], 'loop': true, 'name': 'back', 'speed': 5.0},
		{'frames': [res1, res2], 'loop': true, 'name': 'default', 'speed': 5.0}
		]
		var s = AnimatedSprite.new()
		s.position = Vector2(0, -25)
		s.frames = f
		s.animation = 'default'
		s.play('default')
		var c = stub.default.color
		s.modulate = Color(c.r, c.g, c.b)
		add_child(s)
		gear.push_back(s)
		printt('Added the gear')
	# End for loop

func _ready():
	#var http = HTTPRequest.instance()
	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed", self, "_ack", [])
	#http.request('http://httpbin.org/ip')
	#http.request('http://127.0.0.1:12345/')
	$Tween.connect('tween_started', self, '_tweening_on', [])
	$Tween.connect('tween_completed', self, '_tweening_off', [])


func tween_to (x, y, map):
	dest_x = x
	dest_y = y
	map_pos = Vector2(dest_x, dest_y)
	var destination = map.map_to_world(map_pos) + Vector2(0, 20)
	$Tween.interpolate_property(self, 'position', position, destination, speed,
								Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()

func _ack(result, response_code, headers, body):
	printt("Got something back...")
	printt(result)
	printt(body.get_string_from_utf8())
	var json = JSON.parse(body.get_string_from_utf8())
	if not json: return
	printt(json)
	if not json.result: return
	printt(json.result)
	printt(json.result[0].x)
	printt(json.result[0].y)
	tween_to(json.result[0].x, json.result[0].y)

func _process(delta):
	if moving:
		$AnimatedSprite2.set_flip_h(flip_h)
		$AnimatedSprite2.play(anim)

		#$AnimatedSprite3.modulate = Color(1, 1, .1)
		$AnimatedSprite4.modulate = Color(0, .1, 1)

		for g in gear:
			g.set_flip_h(flip_h)
			if back:
				g.play('back')
			else:
				g.play('default')
		# End for

		$AnimatedSprite4.play('default')
		$AnimatedSprite5.play('default')
		$AnimatedSprite4.set_flip_h(flip_h)
		$AnimatedSprite5.set_flip_h(flip_h)
	else:
		for g in gear:
			g.stop()

		$AnimatedSprite2.set_flip_h(flip_h)
		$AnimatedSprite2.stop()
		$AnimatedSprite4.stop()
		$AnimatedSprite5.stop()

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
