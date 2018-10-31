extends RigidBody2D

export (int) var min_speed # Min
export (int) var max_speed # Max
var mob_types = ["walk", "swim", "fly"]

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _process(delta):
	$AnimatedSprite.play()

func _on_Visibility_screen_exited():
	queue_free()
