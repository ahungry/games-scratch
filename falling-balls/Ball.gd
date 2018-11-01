extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var _gdir_x = 0
var _gdir_y = 0
var screensize

func _integrate_forces(state):
	var dt = state.get_step()
	var gravity = state.get_total_gravity() # The default gravity
	var velocity = state.get_linear_velocity()
	var direction = Vector2(_gdir_x, -1 * _gdir_y) * gravity.length()
	state.set_linear_velocity(velocity + direction * dt)

func _ready():
	screensize = get_viewport_rect().size
	set_use_custom_integrator(true)

func _process(delta):
	_gdir_x = Input.get_accelerometer().x
	_gdir_y = Input.get_accelerometer().y

	if _gdir_y == 0:
		_gdir_y = -1

	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	#if Input.get_accelerometer().x < 0:

	#if Input.get_accelerometer().x < 0:
	#	_gdir_x = -5
	#else:
	#	_gdir_x = 5

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
