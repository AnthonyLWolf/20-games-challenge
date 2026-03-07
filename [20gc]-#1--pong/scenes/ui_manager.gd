extends Control

# References
@onready var player_label: Label = $CanvasLayer/HBoxContainer/PlayerLabel
@onready var cpu_label: Label = $CanvasLayer/HBoxContainer/CPULabel
@onready var centre_text: Control = $CanvasLayer/CentreText
@onready var centre_text_right: Label = $CanvasLayer/CentreText/CentreTextRight
@onready var centre_text_left: Label = $CanvasLayer/CentreText/CentreTextLeft
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		# Handles start game logic
		if !GameManager.game_started && !GameManager.game_over: 
			if event.is_action_pressed("start"):
				_start_game()


func _ready() -> void:
	_set_up_ui()
	
	# Signal that allows centre text to show again
	SignalBus.signal_new_round.connect(func(): centre_text.show())
	SignalBus.signal_game_over.connect(_handle_game_over)
	SignalBus.signal_restart.connect(_set_up_ui)


# Sets up text boxes
func _set_up_ui() -> void:
	centre_text_left.text = "   Press Space"
	centre_text_right.text = "to start"
	centre_text.show()


# Hides text on game start
func _start_game() -> void:
	if centre_text.visible:
		centre_text.hide()


# Handles all the game over conditions for text
func _handle_game_over() -> void:
	if GameManager.player_score >= GameConstants.MAX_SCORE:
		sfx_player.stream = GameConstants.VICTORY
		sfx_player.stop()
		sfx_player.play()
		centre_text_left.text = "You won!!!"
	elif GameManager.cpu_score >= GameConstants.MAX_SCORE:
		sfx_player.stream = GameConstants.GAMEOVER
		sfx_player.stop()
		sfx_player.play()
		centre_text_left.text = "You lost :("
	
	centre_text_right.text = "R to Restart"
