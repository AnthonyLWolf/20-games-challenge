extends Node2D

@onready var marker_2d: Marker2D = $Marker2D
@onready var top_spawn: Marker2D = $TopSpawn
@onready var bottom_spawn: Marker2D = $BottomSpawn

var ball = preload("res://scenes/ball.tscn")

# Spawns ball on start
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("start") && !GameManager.game_started && !GameManager.game_over:
			var instance = ball.instantiate()
			add_child(instance)
			instance.global_position = Vector2(marker_2d.global_position.x, randf_range(top_spawn.global_position.y, bottom_spawn.global_position.y))
