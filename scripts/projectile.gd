extends Area2D

@export var speed := 300.0
var velocity: Vector2

signal hit_target

func _process(delta):
	position += velocity * delta

func set_velocity(direction: Vector2):
	velocity = direction * speed

func _on_body_entered(body):
	hit_target.emit(body)
	queue_free()
