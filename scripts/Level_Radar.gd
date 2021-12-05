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
	
	#this level needs to be more zoomed out than others
	$Player/Camera2D.zoom = Vector2(0.8,0.8);
	
	for boid in get_tree().get_nodes_in_group("boids"):
		boid.connect("playerkilled", self, "playerKilled");
		
func playerKilled():
	$Player.isDead = true;
	$Player/DeathSound.play();
	$RestartTimer.start();
	$CanvasLayer/DeathScreen.visible = true;
	$CanvasLayer/Controls.visible = false;
	for boid in get_tree().get_nodes_in_group("boids"):
		boid.queue_free();

func _on_RestartTimer_timeout():
	get_tree().reload_current_scene();
	
func activate_radar():
	$CanvasLayer/Radar.visible = true;
	for boid in get_tree().get_nodes_in_group("boids"):
		boid.get_node("Sprite").material.light_mode = CanvasItemMaterial.LIGHT_MODE_NORMAL;
	
func deactivate_radar():
	$CanvasLayer/Radar.visible = false;
	for boid in get_tree().get_nodes_in_group("boids"):
		boid.get_node("Sprite").material.light_mode = CanvasItemMaterial.LIGHT_MODE_LIGHT_ONLY;

func _on_button_body_entered(body):
	if(body.is_in_group("players")):
		activate_radar();

func _on_button_body_exited(body):
	if(body.is_in_group("players")):
		deactivate_radar();

func _on_SafeArea_body_entered(body):
	if(body == $Player):
		$Player.set_hidden(true);
		$CanvasLayer/Vignette.modulate.a8 = 255;
		for boid in get_tree().get_nodes_in_group("boids"):
			boid.get_node("BreatheSound").volume_db = -15;

func _on_SafeArea_body_exited(body):
	if(body == $Player):
		$CanvasLayer/Controls.visible = false;
		$Player.set_hidden(false);
		$CanvasLayer/Vignette.modulate.a = 0;
		for boid in get_tree().get_nodes_in_group("boids"):
			boid.get_node("BreatheSound").volume_db = -10;


func _on_ExitArea_body_entered(body):
	if(body == $Player):
		
		#update unlocked levels
		var data = util.load_data("res://data.json");
		data["levels"]["level4"]["unlocked"] = true;
		util.save_data(data, "res://data.json");
		
		get_tree().change_scene("res://scenes/Title.tscn");
