extends State
class_name NpcIdle

@onready var creature = $/root/Game/Creature
@onready var square_face_idle = %SquareFaceIdle
@onready var square_face_flee = %SquareFaceFlee

@export var npc : CharacterBody2D

var move_direction : Vector2
var wander_time : float

const DISTANCE_TO_FLEE := 200

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)

func enter():
	square_face_idle.show()
	square_face_flee.hide()
	randomize_wander()

func state_process(_delta: float):
	if wander_time > 0:
		wander_time -= _delta
	else:
		randomize_wander()

func state_physics_process(_delta: float):
	if npc:
		npc.velocity = move_direction * (npc.move_speed / 2) * npc.speed_multiplier

	if !creature:
		return
	
	if npc.is_dead:
		npc.velocity = Vector2.ZERO
		return

	var creature_distance = creature.global_position - npc.global_position
	
	if creature_distance.length() <= DISTANCE_TO_FLEE:
		transitioned.emit(self, "Flee")
