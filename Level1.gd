extends Node2D

onready var boid = preload("res://Boid.tscn");
var numBoids = 100;
var rng = RandomNumberGenerator.new();
var boids = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize();
	for i in range(numBoids):
		var instance = boid.instance();
		instance.position = $top_left.position;
		instance.rotation = rng.randi_range(0,355);
		boids.append(instance);
		add_child(instance);
		
func _input(event):
	if(Input.is_action_just_pressed("ui_accept")):
		for i in range(0,10):
			var instance = boid.instance();
			instance.position = $top_left.position;
			instance.rotation = rng.randi_range(0,355);
			boids.append(instance);
			add_child(instance);


func _on_cohesion_value_changed(value):
	for boid in boids:
		boid.cohesionForce = value;
	get_node("GridContainer/cohesion_label").text = "cohesion " +str(value);


func _on_align_value_changed(value):
	for boid in boids:
		boid.alignForce = value;
	get_node("GridContainer/align_label").text = "align " +str(value);


func _on_separation_value_changed(value):
	for boid in boids:
		boid.separationForce = value;
	get_node("GridContainer/separation_label").text = "separation " +str(value);


func _on_view_value_changed(value):
	for boid in boids:
		boid.get_node("Area2D/CollisionShape2D").shape.radius = value;
	get_node("GridContainer/view_label").text = "view " +str(value);


func _on_obstacle_value_changed(value):
	for boid in boids:
		boid.avoidCollisionForce = value;
	get_node("GridContainer/obstacle_label").text = "obstacle " +str(value);


func _on_speed_value_changed(value):
	for boid in boids:
		boid.speed = value;
	get_node("GridContainer/speed_label").text = "speed " + str(value);