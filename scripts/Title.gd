extends Control

func _on_Button1_pressed():
	get_tree().change_scene("res://scenes/Level1.tscn")
	
func _on_Button2_pressed():
	get_tree().change_scene("res://scenes/SwitchLevel.tscn")

func _on_Quit_pressed():
	get_tree().quit();
