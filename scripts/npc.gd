extends CharacterBody2D

signal npc_died

@export var move_speed := 165.0
@export var textures : Array[Texture]

@onready var die_sfx = $DieSFX
@onready var ray_cast_front = $RayCastFront
@onready var ray_cast_back = $RayCastBack
@onready var ray_cast_up = $RayCastUp
@onready var ray_cast_down = $RayCastDown
@onready var ray_cast_bottom_left = $RayCastBottomLeft
@onready var ray_cast_top_left = $RayCastTopLeft
@onready var ray_cast_top_right = $RayCastTopRight
@onready var ray_cast_bottom_right = $RayCastBottomRight
@onready var collision_shape = %CollisionShape2D
@onready var square_face_idle = %SquareFaceIdle
@onready var square_face_flee = %SquareFaceFlee
@onready var square_face_die = %SquareFaceDie
@onready var sprite = $SquareBody

var is_dead := false

var directions = [
	Vector2.LEFT, 
	Vector2.RIGHT, 
	Vector2.UP, 
	Vector2.DOWN, 
	Vector2(-1, -1), 
	Vector2(1, -1), 
	Vector2(-1, 1), 
	Vector2(1, 1)
]
var speed_multiplier := 1.0

func _ready():
	pick_body_color()

func _physics_process(delta):
	move_and_slide()

func die():
	if is_dead:
		return

	is_dead = true
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "modulate:a", 0, 0.5)
	tween.tween_property(sprite, "rotation", deg_to_rad(180), 0.5)
	velocity = Vector2.ZERO
	collision_shape.disabled = true
	square_face_die.show()
	square_face_idle.hide()
	square_face_flee.hide()
	die_sfx.play()
	npc_died.emit(self)

func _on_die_sfx_finished():
	queue_free()

func pick_body_color():
	sprite.texture = textures[randi_range(0, textures.size() - 1)]
