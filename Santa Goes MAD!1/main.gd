extends Node2D


func _ready():
	Utils.saveGame()
	Utils.loadGame()




# Handle the "Verlassen" button press event
func _on_verlassen_pressed():
	# Quit the game
	get_tree().quit()


func _on_spielen_pressed():
	get_tree().change_scene_to_file("res://Menus/level_selection.tscn")
