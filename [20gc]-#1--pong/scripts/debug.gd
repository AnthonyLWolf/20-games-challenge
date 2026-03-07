extends Node

# Quits the game with ESC on debug builds
func _unhandled_input(event: InputEvent) -> void:
	if OS.is_debug_build():
		if event.is_action_pressed("debug_quit"):
			get_tree().quit()
