extends KinematicBody2D

signal playerkilled

var cohesionForce = 0.5;
var alignForce = 0.05;
var separationForce = 2.8;
var avoidCollisionForce = 380;
var speed = 100
var attackSpeed = 210;
var playerAttackForce = 300;
var player;
var spaceState;

var velocity;
var rng = RandomNumberGenerator.new();

func _ready():
	rng.randomize();
	velocity = Vector2(rng.randf_range(-1,1)*speed, rng.randf_range(-1,1)*speed);
	player = get_tree().get_nodes_in_group("players")[0];
	$BreatheSound.play();


func cohesion(delta):
	var bodies = $Area2D.get_overlapping_bodies();
	if(bodies.size() < 2):
		return;
	velocity = velocity.normalized();
	var centroid = Vector2.ZERO;
	for body in bodies:
		if(body == self):
			continue;
		centroid += body.position;
	centroid /= bodies.size()-1;
	velocity += (centroid - position) * cohesionForce * delta;
	velocity = velocity.normalized();
	velocity *= speed;
	
	
func separation(delta):
	var bodies = $Area2D.get_overlapping_bodies();
	if(bodies.size() < 2):
		return;
	velocity = velocity.normalized();
	var desired = Vector2.ZERO
	for body in bodies:
		if(body == self):
			continue;
		desired += (position - body.position) / position.distance_to(body.position);
	velocity += desired * delta * separationForce;
	velocity = velocity.normalized();
	velocity *= speed;


func avoid_collision(delta):
	var distanceToCollision;
	velocity = velocity.normalized();
	if ($RayCastStarboard.is_colliding()):
		distanceToCollision = position.distance_to($RayCastStarboard.get_collision_point());
		velocity += velocity.rotated($RayCastStarboard.rotation) * delta * avoidCollisionForce * 1/distanceToCollision ;
	elif ($RayCastPort.is_colliding()):
		distanceToCollision = position.distance_to($RayCastPort.get_collision_point());
		velocity += velocity.rotated(-$RayCastPort.rotation) * delta * avoidCollisionForce * 1/distanceToCollision;
	velocity = velocity.normalized();
	velocity *= speed;


func align(delta):
	var bodies = $Area2D.get_overlapping_bodies();
	if(bodies.size() < 2):
		return
	velocity = velocity.normalized();
	var avg = Vector2.ZERO;
	for body in bodies:
		if(body == self):
			continue;
		avg += body.velocity;
	avg /= bodies.size();
	velocity += (avg - velocity) * alignForce * delta;
	velocity = velocity.normalized();
	velocity *= speed;


func attack(delta):
	var bodies = $playerDetectionArea.get_overlapping_bodies();
	if(bodies.size() == 1):
		if player.is_hidden():
			$RunningSound.stop();
			return;
		var raycast = spaceState.intersect_ray(position, player.position, [self], 0b00000000000000001110);
		if(!raycast):
			$RunningSound.stop();
			return;
		if(raycast.collider != player):
			$RunningSound.stop();
			return;
		if(!$RunningSound.playing):
			$RunningSound.play();
			$AlertSound.play();
		velocity += (player.position - position) * playerAttackForce * delta;
		velocity = velocity.normalized();
		velocity *= attackSpeed;


func _physics_process(delta):

	spaceState = get_world_2d().direct_space_state

	cohesion(delta);
	separation(delta);
	align(delta);
	avoid_collision(delta);
	attack(delta);
	move_and_slide(velocity)
	if(position.distance_to(player.position)<10):
		emit_signal("playerkilled");

	rotation = velocity.angle()
