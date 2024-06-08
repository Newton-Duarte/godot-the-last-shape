extends State
class_name EnemyFollow

@export var creature : CharacterBody2D
@export var move_speed := 100.0
@onready var use_skill_timer = %UseSkillTimer

func state_physics_process(_delta: float):
	if !creature.current_target:
		transitioned.emit(self, "Idle")
		return

	var target_distance = creature.current_target.global_position - creature.global_position
	creature.velocity = target_distance.normalized() * move_speed * creature.speed_multiplier


func schedule_next_skill():
	var interval := randf_range(5, 8)
	use_skill_timer.start(interval)

func pick_random_skill():
	var skill_choice = randi_range(0, 1)
	match skill_choice:
		0:
			transitioned.emit(self, "Charge")
		1:
			transitioned.emit(self, "Shoot")

func _on_use_skill_timer_timeout():
	pick_random_skill()
