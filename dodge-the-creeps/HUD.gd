extends CanvasLayer

signal start_game

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$StartButton.show()
	$MessageLabel.text = "Dodge the\nCreeps!"
	$MessageLabel.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_MessageTimer_timeout():
	$MessageLabel.hide()

# https://docs.godotengine.org/en/3.0/tutorials/networking/http_request_class.html?highlight=http
func _on_StartButton_pressed():
	$HTTPRequest.request("http://httpbin.org/ip")
	$StartButton.hide()
	emit_signal("start_game")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	printt(json.result)
	show_message("Your IP was: " + json.result.origin)
