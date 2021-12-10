extends Control
var util = load("res://scripts/Util.gd").new();

func _process(delta):
	if(Input.is_action_just_pressed("ui_cancel")):
		get_tree().quit();

func _ready():
	$music.play();
	var data = util.load_data("res://data.json");
	
	if(data["levels"]["level1"]["unlocked"]):
		$"CenterContainer/VBoxContainer/Level Select/GridContainer/Button1".disabled = false;
	if(data["levels"]["level2"]["unlocked"]):
		$"CenterContainer/VBoxContainer/Level Select/GridContainer/Button2".disabled = false;
	if(data["levels"]["level3"]["unlocked"]):
		$"CenterContainer/VBoxContainer/Level Select/GridContainer/Button3".disabled = false;

func _on_Button1_pressed():
	get_tree().change_scene("res://scenes/Level1.tscn")
	
func _on_Button2_pressed():
	get_tree().change_scene("res://scenes/SwitchLevel.tscn")
	
func _on_Button3_pressed():
	get_tree().change_scene("res://scenes/Level_Radar.tscn")

func _on_Quit_pressed():
	get_tree().quit();
