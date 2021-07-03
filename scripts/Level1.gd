extends Node2D

onready var boidScene = preload("res://scenes/Boid.tscn");
var numBoids = 100;
var rng = RandomNumberGenerator.new();
var boids = [];

#Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize();
	var angle;
	var radius;
	var x;
	var y;
	
	for boid in get_tree().get_nodes_in_group("boids"):
		boid.connect("playerkilled", self, "playerKilled");
	
func _on_cohesion_value_changed(value):
	for boid in get_tree().get_nodes_in_group("boids"):
		boid.cohesionForce = value;
	get_node("CanvasLayer/GridContainer/cohesion_label").text = "cohesion " +str(value);


func _on_align_value_changed(value):
	for boid in get_tree().get_nodes_in_group("boids"):
		boid.alignForce = value;
	get_node("CanvasLayer/GridContainer/align_label").text = "align " +str(value);


func _on_separation_value_changed(value):
	for boid in get_tree().get_nodes_in_group("boids"):
		boid.separationForce = value;
	get_node("CanvasLayer/GridContainer/separation_label").text = "separation " +str(value);


func _on_view_value_changed(value):
	for boid in get_tree().get_nodes_in_group("boids"):
		boid.get_node("Area2D/CollisionShape2D").shape.radius = value;
	get_node("CanvasLayer/GridContainer/view_label").text = "view " +str(value);


func _on_obstacle_value_changed(value):
	for boid in get_tree().get_nodes_in_group("boids"):
		boid.avoidCollisionForce = value;
	get_node("CanvasLayer/GridContainer/obstacle_label").text = "obstacle " +str(value);


func _on_speed_value_changed(value):
	for boid in get_tree().get_nodes_in_group("boids"):
		boid.speed = value;
	get_node("CanvasLayer/GridContainer/speed_label").text = "speed " + str(value);

func _on_Area2D_body_entered(body):
	$CanvasLayer/GridContainer/hidden.text = "HIDDEN";
	if(body == $Player):
		$Player.set_hidden(true);
		
func _on_Area2D_body_exited(body):
	$CanvasLayer/GridContainer/hidden.text = "EXPOSED";
	if(body == $Player):
		$Player.set_hidden(false);
		
func playerKilled():
	get_tree().reload_current_scene();

func _on_WinArea_body_entered(body):
	if(body == $Player):
		get_tree().reload_current_scene();
