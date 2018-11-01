extends CanvasLayer

export (PackedScene) var HUD
var score = 0

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	#$Score.text = str(score)
	$Score.text = str(get_tree().get_nodes_in_group("balls").size())
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
