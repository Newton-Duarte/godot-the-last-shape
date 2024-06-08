extends State
class_name EnemyIdle

@export var creature : CharacterBody2D
@export var move_speed := 100.0

var move_direction : Vector2
var wander_time : float

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)

func enter():
	randomize_wander()

func state_process(_delta: float):
	if wander_time > 0:
		wander_time -= _delta
	else:
		randomize_wander()

func state_physics_process(_delta: float):
	if creature:
		creature.velocity = move_direction * move_speed * creature.speed_multiplier
	
	if creature.current_target:
		transitioned.emit(self, "Follow")
