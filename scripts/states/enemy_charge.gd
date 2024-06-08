extends State
class_name EnemyCharge

@export var creature : CharacterBody2D
@export var charge_speed := 600.0

var is_charging := false

func state_physics_process(_delta: float):
	if is_charging:
		return

	charge_skill()

func charge_skill():
	is_charging = true

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
			target = creature.all_targets[randi_range(0, creature.all_targets.size() - 1)]

	var direction = (target.global_position - creature.global_position).normalized()
	var charge_velocity = direction * charge_speed

	creature.velocity = charge_velocity
	
	await get_tree().create_timer(1).timeout
	
	creature.velocity = Vector2()
	await get_tree().create_timer(0.5).timeout
	
	transitioned.emit(self, "Follow")
	is_charging = false
