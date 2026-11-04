extends GutTest

const PlayerScene: PackedScene = preload("res://scenes/player.tscn")

var player: Player


func before_each() -> void:
	player = PlayerScene.instantiate() as Player
	player.max_health = 100
	add_child_autofree(player)
	watch_signals(player)


func test_starts_at_max_health() -> void:
	assert_eq(player.health, 100)


func test_take_damage_reduces_health() -> void:
	player.take_damage(30)
	assert_eq(player.health, 70)
	assert_signal_emitted_with_parameters(player, "health_changed", [70, 100])
	assert_signal_not_emitted(player, "died")


func test_health_does_not_go_below_zero() -> void:
	player.take_damage(250)
	assert_eq(player.health, 0)


func test_died_emitted_when_health_reaches_zero() -> void:
	player.take_damage(100)
	assert_signal_emitted(player, "died")
	assert_true(player.is_dead())


func test_died_emitted_only_once() -> void:
	player.take_damage(100)
	player.take_damage(10)
	assert_signal_emit_count(player, "died", 1)


func test_zero_or_negative_damage_is_ignored() -> void:
	player.take_damage(0)
	player.take_damage(-5)
	assert_eq(player.health, 100)
	assert_signal_not_emitted(player, "health_changed")


func test_is_dead_false_while_alive() -> void:
	assert_false(player.is_dead())
	player.take_damage(99)
	assert_false(player.is_dead())
	assert_eq(player.health, 1)


func test_exact_lethal_damage() -> void:
	player.take_damage(100)
	assert_eq(player.health, 0)
	assert_signal_emitted_with_parameters(player, "health_changed", [0, 100])
	assert_signal_emit_count(player, "died", 1)


func test_overkill_damage_reports_zero() -> void:
	player.take_damage(250)
	assert_signal_emitted_with_parameters(player, "health_changed", [0, 100])
	assert_signal_emit_count(player, "died", 1)
	assert_true(player.is_dead())


func test_multiple_hits_accumulate() -> void:
	player.take_damage(10)
	player.take_damage(20)
	player.take_damage(30)
	assert_eq(player.health, 40)
	assert_signal_emit_count(player, "health_changed", 3)
	assert_signal_emitted_with_parameters(player, "health_changed", [40, 100])
	assert_signal_not_emitted(player, "died")


func test_accumulated_hits_can_kill() -> void:
	player.take_damage(60)
	player.take_damage(60)
	assert_eq(player.health, 0)
	assert_signal_emit_count(player, "died", 1)


func test_health_changed_not_emitted_after_death() -> void:
	player.take_damage(100)
	player.take_damage(10)
	player.take_damage(50)
	assert_signal_emit_count(player, "health_changed", 1)
	assert_eq(player.health, 0)


func test_custom_max_health_before_ready() -> void:
	var custom: Player = PlayerScene.instantiate() as Player
	custom.max_health = 250
	add_child_autofree(custom)
	watch_signals(custom)
	assert_eq(custom.health, 250)
	custom.take_damage(50)
	assert_signal_emitted_with_parameters(custom, "health_changed", [200, 250])


func test_health_cannot_be_set_directly() -> void:
	player.health = 0
	assert_push_error("read-only")
	assert_eq(player.health, 100)
	assert_signal_not_emitted(player, "health_changed")


func test_full_health_before_entering_tree() -> void:
	var loose: Player = PlayerScene.instantiate() as Player
	assert_eq(loose.health, 100)
	assert_false(loose.is_dead())
	loose.take_damage(30)
	assert_eq(loose.health, 70)
	loose.free()


func test_damage_before_tree_survives_ready() -> void:
	var loose: Player = PlayerScene.instantiate() as Player
	loose.take_damage(30)
	add_child_autofree(loose)
	assert_eq(loose.health, 70)


func test_max_health_clamped_to_at_least_one() -> void:
	var loose: Player = PlayerScene.instantiate() as Player
	loose.max_health = 0
	assert_eq(loose.max_health, 1)
	assert_false(loose.is_dead())
	loose.max_health = -50
	assert_eq(loose.max_health, 1)
	loose.free()


func test_lowering_max_health_clamps_current_health() -> void:
	player.max_health = 40
	assert_eq(player.health, 40)
	player.max_health = 200
	assert_eq(player.health, 40)
