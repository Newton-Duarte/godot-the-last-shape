extends State
class_name EnemyShoot

@export var creature : CharacterBody2D
@export var projectile_scene: PackedScene = preload("res://scenes/projectile.tscn")
@onready var shoot_sfx = %ShootSFX

@onready var shooting_point = %ShootingPoint

var is_attacking := false

func state_physics_process(_delta: float):
	if is_attacking:
		return

	ranged_attack_skill()

func ranged_attack_skill():
	is_attacking = true
	
	var targets = creature.all_targets

	if creature.all_targets.size() == 0:
		transitioned.emit(self, "Idle")
		return

	creature.velocity = Vector2()
	await get_tree().create_timer(0.5).timeout
	
	var target
	var target_choice = randi_range(0, 1)
	match target_choice:
		0:
			target = creature.fartest_target
		1:
			target = targets[randi_range(0, targets.size() - 1)]

	if !target:
		stop_attack()
		return

	var projectile = projectile_scene.instantiate()
	projectile.connect("hit_target", creature._on_kill_area_body_entered)
	creature.add_child(projectile)
	shoot_sfx.play()

	var direction = (target.global_position - creature.global_position).normalized()
	projectile.global_position = shooting_point.global_position
	projectile.global_rotation = shooting_point.global_rotation
	projectile.set_velocity(direction * 1.5)
	stop_attack()

func stop_attack():
	await get_tree().create_timer(0.5).timeout
	transitioned.emit(self, "Follow")
	is_attacking = false
