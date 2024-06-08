extends CharacterBody2D

signal player_died

const SPEED := 150
const DASH_SPEED := 600
const DASH_DURATION := 0.2
const DASH_COOLDOWN := 5.0

@export var health := 100.0

@onready var dash_sfx = $DashSFX
@onready var die_sfx = $DieSFX
@onready var dash_timer = $DashTimer
@onready var dash_cooldown_timer = $DashCooldownTimer
@onready var square_face_idle = %SquareFaceIdle
@onready var square_face_flee = %SquareFaceFlee
@onready var square_face_die = %SquareFaceDie

var is_dead := false
var is_dashing := false
var dash_direction := Vector2.ZERO

func _ready():
	square_face_idle.show()
	square_face_flee.hide()
	square_face_die.hide()

func _physics_process(delta):
	if Input.is_action_just_pressed("dash") and not is_dashing and dash_cooldown_timer.time_left == 0:
		start_dash()
	
	if is_dashing:
		velocity = dash_direction * DASH_SPEED
	else:
		handle_movement()

	move_and_slide()
	
	if velocity.length() > 0.0:
		square_face_idle.hide()
		square_face_flee.show()
		#print("Animate walk")
	else:
		square_face_flee.hide()
		square_face_idle.show()
		#print("Animate idle")

func handle_movement():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED

func die():
	is_dead = true
	square_face_die.show()
	square_face_flee.hide()
	square_face_idle.hide()
	die_sfx.play()
	player_died.emit()

func start_dash():
	dash_direction = get_movement_input().normalized()
	if dash_direction == Vector2.ZERO:
		return

	dash_sfx.play()
	is_dashing = true
	dash_timer.start(DASH_DURATION)
	dash_cooldown_timer.start(DASH_COOLDOWN)
	
func get_movement_input() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

func _on_dash_timer_timeout():
	is_dashing = false


func _on_dash_cooldown_timer_timeout():
	pass
