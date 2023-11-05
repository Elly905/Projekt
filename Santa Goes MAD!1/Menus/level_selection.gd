extends Node2D



func _on_menu_pressed():
	get_tree().change_scene_to_file("res://menus/main.tscn")



func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://Levels/level_1.tscn")



func _on_level_2_pressed():
	get_tree().change_scene_to_file("res://Levels/level_2.tscn")
