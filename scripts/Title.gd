extends Control

func _ready():
	#get data from save state
	var file = File.new();
	file.open("res://data.json", File.READ);
	var json_str = file.get_as_text();
	var data = {};
	data = parse_json(json_str);
	file.close();
	
	if(data["levels"]["level1"]["unlocked"]):
		$"CenterContainer/VBoxContainer/Level Select/GridContainer/Button1".disabled = false;
	if(data["levels"]["level2"]["unlocked"]):
		$"CenterContainer/VBoxContainer/Level Select/GridContainer/Button2".disabled = false;

func _on_Button1_pressed():
	get_tree().change_scene("res://scenes/Level1.tscn")
	
func _on_Button2_pressed():
	get_tree().change_scene("res://scenes/SwitchLevel.tscn")

func _on_Quit_pressed():
	get_tree().quit();
