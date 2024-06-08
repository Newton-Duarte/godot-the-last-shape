extends CharacterBody2D

@onready var roar_sfx = $RoarSFX
@onready var use_skill_timer = $UseSkillTimer

var all_targets = []
var current_target : CharacterBody2D
var fartest_target : CharacterBody2D
var speed_multiplier := 1.0
var can_move := false

const MAX_SPEED_MULTIPLIER := 1.5

func _ready():
	roar_sfx.play()

func _physics_process(delta):
	if !can_move:
		return
	
	move_and_slide()
	
	var targets = get_tree().get_first_node_in_group("Targets").get_children()
	all_targets = targets
	get_nearest_target(targets)
	get_fartest_target(targets)
			
	if !targets.size() and current_target:
		current_target = null
	
	if velocity.length() > 0:
		#print("Animate walk")
		pass
	
	#if velocity.x > 0:
		#$Sprite2D.flip_h = false
	#else:
		#$Sprite2D.flip_h = true

func get_nearest_target(targets):
	var nearest_target_distance = INF
	
	for target in targets:
		if !target.visible or target.is_dead:
			continue

		var target_distance = position.distance_to(target.position)
		if target_distance < nearest_target_distance:
			nearest_target_distance = target_distance
			current_target = target

func get_fartest_target(targets):
	var fartest_target_distance = 0

	for target in targets:
		if !target.visible or target.is_dead:
			continue

		var target_distance = position.distance_to(target.position)
		if target_distance > fartest_target_distance:
			fartest_target_distance = target_distance
			fartest_target = target

func _on_kill_area_body_entered(body):
	if body.has_method("die"):
		body.die()
		roar_sfx.play()
		increase_speed()

func increase_speed():
	if speed_multiplier >= MAX_SPEED_MULTIPLIER:
			return

	speed_multiplier += 0.25

func _on_roar_sfx_finished():
	can_move = true
