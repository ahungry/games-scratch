extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var gravity_direction = 0

func _integrate_forces(state):
	var dt = state.get_step()
	var gravity = state.get_total_gravity() # The default gravity
	var velocity = state.get_linear_velocity()
	var direction = Vector2(gravity_direction, 1) * gravity.length()
	state.set_linear_velocity(velocity + direction * dt)

func _ready():
	set_use_custom_integrator(true)

func _process(delta):
	gravity_direction = Input.get_accelerometer().x
	#if Input.get_accelerometer().x < 0:

	#if Input.get_accelerometer().x < 0:
	#	gravity_direction = -5
	#else:
	#	gravity_direction = 5

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
