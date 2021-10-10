extends Light2D

var posSwayAmount = 7;
var intensityMin = 1.8;
var intensityMax = 2.2;

var targetEnergy : float = 0;
var targetPos : Vector2;

var rng : RandomNumberGenerator;
var origin : Vector2;

func _ready():
	origin = position;
	rng = RandomNumberGenerator.new();
	rng.randomize();
	targetEnergy = rng.randf_range(intensityMin, intensityMax);
	targetPos = newTargetPosition(posSwayAmount, origin);
	
func _physics_process(delta):
	energy = lerp(energy,targetEnergy,delta*3)
	if(abs(energy-targetEnergy) < 0.1):
		targetEnergy = rng.randf_range(intensityMin, intensityMax);
	position = lerp(position, targetPos, delta*5);
	if(position.distance_to(targetPos)<1):
		targetPos = newTargetPosition(posSwayAmount, origin);

func newTargetPosition(posSwayAmount, origin):
	var angle : int = rng.randi_range(0,355);
	var distance : int = rng.randi_range(0, posSwayAmount);
	var target : Vector2;
	
	target.x = origin.x;
	target.y = origin.y;
	
	#convert polar coordinates to cartesian coordinates
	target.x += distance*cos(angle);
	target.y += distance*sin(angle);
	
	return target;
