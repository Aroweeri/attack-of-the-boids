extends KinematicBody2D

var speed = 150
var invincible = false;

var velocity = Vector2()
var hidden = true;
var isDead = false;

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed;


func _physics_process(_delta):
	if(isDead):
		return;
	get_input()
	velocity = move_and_slide(velocity)


func set_hidden(hidden):
	self.hidden = hidden;


func is_hidden():
	return self.hidden;
