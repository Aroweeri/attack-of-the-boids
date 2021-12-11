extends Node2D

onready var boidScene = preload("res://scenes/Boid.tscn");
var util = load("res://scripts/Util.gd").new();
var numBoids = 100;
var rng = RandomNumberGenerator.new();
var boids = [];
var buttonPressed = false;

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
		boid.cohesionForce = 0;
		boid.alignForce = 0;
		boid.separationForce = 4;
		boid.get_node("BreatheSound").playing = false;

	$Music.play();


func playerKilled():
	$Player.isDead = true;
	$Player/DeathSound.play();
	$Music.stop();
	$RestartTimer.start();
	$CanvasLayer/DeathScreen.visible = true;
	$CanvasLayer/Controls.visible = false;
	for boid in get_tree().get_nodes_in_group("boids"):
		boid.queue_free();


func _on_RestartTimer_timeout():
	get_tree().reload_current_scene();


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
		data["levels"]["level3"]["unlocked"] = true;
		util.save_data(data, "res://data.json");
		
		get_tree().change_scene("res://scenes/Title.tscn");


func _on_button_body_entered(body):
	if(not buttonPressed):
		if(body == $Player):
			buttonPressed = true;
			$button/Sprite.modulate = Color(0.2,0.2,0.2);
			$PlayerDoor1.queue_free();
			$PlayerDoor2.queue_free();
			$BoidDoor1.queue_free();
			$BoidDoor2.queue_free();
			$BoidDoor3.queue_free();
			$BoidDoor4.queue_free();
			for boid in get_tree().get_nodes_in_group("boids"):
				boid.get_node("BreatheSound").playing = true;
