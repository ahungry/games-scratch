extends Node2D

#export (PackedScene) var Truck
var Unit = preload('res://Unit.tscn')
var units = []

const N = 0x1
const E = 0x2
const S = 0x4
const W = 0x8

var cell_walls = {Vector2(0, -1): N, Vector2(1, 0): E,
				  Vector2(0, 1): S, Vector2(-1, 0): W}

onready var Map = $TileMap

func _ready():
	$Truck.map = Map
	$Truck.map_pos = Vector2(0, 0)
	$Truck.position = Map.map_to_world($Truck.map_pos) + Vector2(0, 20)

	fetch_world()
	var mt = Timer.new()
	mt.process_mode = 1
	mt.wait_time = 1.0
	mt.one_shot = false
	mt.autostart = true
	mt.connect('timeout', self, 'fetch_world', [])
	add_child(mt)

	# Just make a bunch of cells out of the gate.
	for x in range(10):
		for y in range(10):
			Map.set_cell(x, y, 0)


func fetch_world():
	# Pull in some remote stuff (TODO: Add timer for this)
	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed", self, "_ack", [])
	#http.request('http://httpbin.org/ip')
	http.request('http://127.0.0.1:12345/')

func _ack(result, response_code, headers, body):
	printt("Got something back...")
	printt(result)
	printt(body.get_string_from_utf8())
	var json = JSON.parse(body.get_string_from_utf8())
	if not json: return
	printt(json)
	if not json.result: return
	printt(json.result)
	for i in range(0, json.result.size()):
		# See if the unit already exists or not.
		var existing = false
		for u in units:
			printt('...' + u.unit_name + '...')
			printt('VERSUS')
			printt('...' + json.result[i].name + '...')
			if u.unit_name == json.result[i].name:
				printt('FOUND A MATCH')
				existing = u

		printt(existing)
		if existing:
			existing.tween_to(json.result[i].x, json.result[i].y, Map)
		else:
			printt('Found name: ' + json.result[i].name)
			var m = Unit.instance()
			m.boot(json.result[i].name, json.result[i].gear)
			m.map = Map
			m.tween_to(json.result[i].x, json.result[i].y, Map)
			units.push_back(m)
			add_child(m)
		# else
	# for

func generate_tile(cell):
	var cells = find_valid_tiles(cell)
	Map.set_cellv(cell, cells[randi() % cells.size()])

func find_valid_tiles(cell):
	var valid_tiles = []
	# returns all valid tiles for a given cell
	for i in range(16):
		# check target space's neighbors (if they exist)
		var is_match = false
		for n in cell_walls.keys():
			var neighbor_id = Map.get_cellv(cell + n)
			if neighbor_id >= 0:
				if (neighbor_id & cell_walls[-n])/cell_walls[-n] == (i & cell_walls[n])/cell_walls[n]:
					is_match = true
				else:
					is_match = false
					break
		if is_match and not i in valid_tiles:
			valid_tiles.append(i)
	return valid_tiles
