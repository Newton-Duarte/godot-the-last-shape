extends State
class_name NpcFlee

@onready var creature = $/root/Game/Creature
@onready var square_face_idle = %SquareFaceIdle
@onready var square_face_flee = %SquareFaceFlee
@onready var dash_timer = %DashTimer
@onready var dash_cooldown_timer = %DashCooldownTimer

@export var npc : CharacterBody2D

const DISTANCE_TO_STOP_FLEE := 300
const DISTANCE_TO_USE_DASH := 100

const DASH_SPEED := 600
const DASH_DURATION := 0.2
const DASH_COOLDOWN := 5.0

var max_steering_force := 1.0
var avoid_force := 1

var dash_direction := Vector2.ZERO
var is_dashing := false

func enter():
	square_face_flee.show()
	square_face_idle.hide()

func state_physics_process(_delta: float):
	if npc.is_dead:
		npc.velocity = Vector2.ZERO
		return

	if !creature:
		transitioned.emit(self, "Idle")
		return
		
	# Get creature distance
	var creature_distance = creature.global_position - npc.global_position
	
	# Calculate fleeing direction
	var flee_direction = (npc.global_position - creature.global_position).normalized()
	
	# Apply obstacle avoidance
	var avoid_steering = avoid_obstacles_steering()
	
	# Combine steering forces
	var desired_velocity = (flee_direction + avoid_steering).normalized() * npc.move_speed
	
	if is_dashing:
		npc.velocity = dash_direction * DASH_SPEED
	else:
		# Update NPC velocity
		npc.velocity = desired_velocity * npc.speed_multiplier
	
	if creature_distance.length() <= DISTANCE_TO_USE_DASH and !is_dashing and dash_cooldown_timer.time_left == 0:
		start_dash()
	
	if creature_distance.length() >= DISTANCE_TO_STOP_FLEE:
		npc.velocity = Vector2()
		transitioned.emit(self, "Idle")
	
func avoid_obstacles_steering():
	var steering = Vector2.ZERO
	var raycasts = [
		npc.ray_cast_front,
		npc.ray_cast_back,
		npc.ray_cast_up,
		npc.ray_cast_down,
		npc.ray_cast_bottom_left,
		npc.ray_cast_top_left,
		npc.ray_cast_top_right,
		npc.ray_cast_bottom_right
	]
	
	var directions = [
		Vector2.RIGHT,   # Front
		Vector2.LEFT,  # Back
		Vector2.UP,  # Up
		Vector2.DOWN,   # Down
		Vector2(-1, -1), # Top Left
		Vector2(1, -1),  # Top Right
		Vector2(-1, 1),  # Bottom Left
		Vector2(1, 1)    # Bottom Right
	]

	for i in range(raycasts.size()):
		if raycasts[i].is_colliding():
			steering += -directions[i].normalized() * avoid_force / npc.move_speed
		
	return steering.normalized()

func start_dash():
	var creature_position = creature.global_position
	
	var left_dash_directions = [
		Vector2(-1, -1), # Top Left
		Vector2.LEFT,  # Top Right
		Vector2(-1, 1),  # Bottom Left
	]
	
	var right_dash_directions = [
		Vector2(1, -1), # Top Right
		Vector2.RIGHT,  # Right
		Vector2(1, 1)    # Bottom Right
	]
	
	var top_dash_directions = [
		Vector2(-1, -1), # Top Left
		Vector2.UP,  # Up
		Vector2(1, -1), # Top Right
	]
	
	var bottom_dash_directions = [
		Vector2(-1, 1),  # Bottom Left
		Vector2.DOWN,  # Up
		Vector2(1, 1)    # Bottom Right
	]
	
	if creature_position.x > npc.position.x:
		dash_direction = left_dash_directions[randi_range(0, left_dash_directions.size() - 1)]
	else:
		dash_direction = right_dash_directions[randi_range(0, right_dash_directions.size() - 1)]
	
	if dash_direction == Vector2.ZERO:
		return

	is_dashing = true
	dash_timer.start(DASH_DURATION)
	dash_cooldown_timer.start(DASH_COOLDOWN)


func _on_dash_timer_timeout():
	is_dashing = false
