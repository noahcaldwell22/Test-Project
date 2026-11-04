class_name Player
extends CharacterBody2D

## Emitted whenever health changes, so UI can update without polling.
signal health_changed(current: int, maximum: int)
## Emitted once, when health first reaches zero.
signal died

## Always at least 1. Setting it before the player enters the tree also
## resets health to full; after that, health is only clamped to the new max.
@export_range(1, 9999) var max_health: int = 100:
	set(value):
		max_health = maxi(value, 1)
		if is_node_ready():
			_health = mini(_health, max_health)
		else:
			_health = max_health

## Read-only. Change it with take_damage() so signals always fire.
var health: int:
	get:
		return _health
	set(_value):
		push_error("Player.health is read-only; use take_damage().")

var _health: int = max_health


func take_damage(amount: int) -> void:
	if amount <= 0 or is_dead():
		return
	_health = maxi(_health - amount, 0)
	health_changed.emit(_health, max_health)
	if _health == 0:
		died.emit()


func is_dead() -> bool:
	return _health <= 0
