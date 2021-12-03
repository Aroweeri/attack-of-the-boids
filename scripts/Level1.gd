extends Node2D

onready var boidScene = preload("res://scenes/Boid.tscn");
var util = load("res://scripts/Util.gd").new();
var numBoids = 100;
var rng = RandomNumberGenerator.new();
var boids = [];

func _process(delta):
	if(Input.is_action_just_pressed("ui_cancel")):
		get_tree().change_scene("res://scenes/Title.tscn");

func _ready():
	rng.randomize();
	var angle;
	var radius;
	var x;
	var y;
	
	for boid in get_tree().get_nodes_in_group("boids"):
		boid.connect("playerkilled", self, "playerKilled");

func _on_Area2D_body_entered(body):
	if(body == $Player):
		$Player.set_hidden(true);
		$CanvasLayer/Vignette.modulate.a8 = 255;
		for boid in get_tree().get_nodes_in_group("boids"):
			boid.get_node("BreatheSound").volume_db = -15;


func _on_Area2D_body_exited(body):
	if(body == $Player):
		$CanvasLayer/Controls/GetToTheExit.visible = false;
		$Player.set_hidden(false);
		$CanvasLayer/Vignette.modulate.a = 0;
		for boid in get_tree().get_nodes_in_group("boids"):
			boid.get_node("BreatheSound").volume_db = -10;


func playerKilled():
	$Player/DeathSound.play();
	$RestartTimer.start();
	$CanvasLayer/DeathScreen.visible = true;
	$CanvasLayer/Controls.visible = false;
	for boid in get_tree().get_nodes_in_group("boids"):
		boid.queue_free();
	

func _on_WinArea_body_entered(body):
	if(body == $Player):
		
		#update unlocked levels
		var data = util.load_data("res://data.json");
		data["levels"]["level2"]["unlocked"] = true;
		util.save_data(data, "res://data.json");
		
		get_tree().change_scene("res://scenes/Title.tscn");

func _on_RestartTimer_timeout():
	get_tree().reload_current_scene();
