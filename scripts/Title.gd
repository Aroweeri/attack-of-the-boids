extends Control
var util = load("res://scripts/Util.gd").new();
var data;

func _process(delta):
	if(Input.is_action_just_pressed("ui_cancel")):
		util.save_data(data, "res://data.json");
		get_tree().quit();

func _ready():
	data = util.load_data("res://data.json");
	
	if(data["levels"]["level1"]["unlocked"]):
		$"CenterContainer/VBoxContainer/Level Select/GridContainer/Button1".disabled = false;
	if(data["levels"]["level2"]["unlocked"]):
		$"CenterContainer/VBoxContainer/Level Select/GridContainer/Button2".disabled = false;
	if(data["levels"]["level3"]["unlocked"]):
		$"CenterContainer/VBoxContainer/Level Select/GridContainer/Button3".disabled = false;
		
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(data["music"]["value"]));
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(data["sfx"]["value"]));
	
	$CenterContainer/VBoxContainer/CenterContainer/Control/MusicHBox/Slider.value = data["music"]["value"];
	$CenterContainer/VBoxContainer/CenterContainer/Control/SFXHBox/Slider.value = data["sfx"]["value"];
	
	#We connect this signal in code so that the above lines don't trigger the signal when the scene is first loaded.
	$CenterContainer/VBoxContainer/CenterContainer/Control/SFXHBox/Slider.connect("value_changed", self, "_on_SFXSlider_value_changed");
	
	$music.play();

func _on_Button1_pressed():
	util.save_data(data, "res://data.json");
	get_tree().change_scene("res://scenes/Level1.tscn");
	
func _on_Button2_pressed():
	util.save_data(data, "res://data.json");
	get_tree().change_scene("res://scenes/SwitchLevel.tscn");
	
func _on_Button3_pressed():
	util.save_data(data, "res://data.json");
	get_tree().change_scene("res://scenes/Level_Radar.tscn");

func _on_Quit_pressed():
	util.save_data(data, "res://data.json");
	get_tree().quit();

func _on_SFXSlider_value_changed(value):
	data["sfx"]["value"] = value;
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(data["sfx"]["value"]));
	if($SFXTest.playing == false):
		$SFXTest.play();

func _on_MusicSlider_value_changed(value):
	data["music"]["value"] = value;
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(data["music"]["value"]));
