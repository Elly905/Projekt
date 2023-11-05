extends Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Update the label's text to display the current player HP
	text = "HP: " + str(Game.playerHP)
