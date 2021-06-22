extends Node2D

onready var boidScene = preload("res://scenes/Boid.tscn");
var numBoids = 10;
var rng = RandomNumberGenerator.new();
var boids = [];

#Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize();
	var angle;
	var radius;
	var x;
	var y;
	for _i in range(numBoids):
		var instance = boidScene.instance();
		
		#Get random positions in circle around spawn area
		angle = rng.randf() * 2 * PI;
		radius = 4 * sqrt(rng.randf());
		x = radius * cos(angle) + $spawn.position.x;
		y = radius * sin(angle) + $spawn.position.y;
		
		instance.position = Vector2(x,y);
		instance.rotation = rng.randi_range(0,355);
		boids.append(instance);
		add_child(instance);
		
#func _input(_event):
#	if(Input.is_action_just_pressed("ui_accept")):
#		for _i in range(0,10):
#			var instance = boidScene.instance();
#			instance.position = $top_left.position;
#			instance.rotation = rng.randi_range(0,355);
#			boids.append(instance);
#			add_child(instance);


func _on_cohesion_value_changed(value):
	for boid in self.boids:
		boid.cohesionForce = value;
	get_node("GridContainer/cohesion_label").text = "cohesion " +str(value);


func _on_align_value_changed(value):
	for boid in self.boids:
		boid.alignForce = value;
	get_node("GridContainer/align_label").text = "align " +str(value);


func _on_separation_value_changed(value):
	for boid in self.boids:
		boid.separationForce = value;
	get_node("GridContainer/separation_label").text = "separation " +str(value);


func _on_view_value_changed(value):
	for boid in self.boids:
		boid.get_node("Area2D/CollisionShape2D").shape.radius = value;
	get_node("GridContainer/view_label").text = "view " +str(value);


func _on_obstacle_value_changed(value):
	for boid in self.boids:
		boid.avoidCollisionForce = value;
	get_node("GridContainer/obstacle_label").text = "obstacle " +str(value);


func _on_speed_value_changed(value):
	for boid in self.boids:
		boid.speed = value;
	get_node("GridContainer/speed_label").text = "speed " + str(value);
