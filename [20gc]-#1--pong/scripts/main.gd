extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# Handles game flow with signals
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("start") && !GameManager.game_started:
			SignalBus.signal_start_game.emit()
		if event.is_action_pressed("restart"):
			SignalBus.signal_restart.emit()
