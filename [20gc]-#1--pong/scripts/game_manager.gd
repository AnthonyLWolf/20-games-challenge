extends Node

@onready var viewport_size : Vector2i = get_viewport().size

# Core game variables
var game_started : bool = false
var game_over : bool = false
var single_player : bool = true

# Setters for score
var player_score : int = 0:
	set(new_score):
		player_score = new_score
		UiManager.player_label.text = str(player_score)
var cpu_score : int = 0:
	set(new_score):
		cpu_score = new_score
		UiManager.cpu_label.text = str(cpu_score) 


# Connects all signals
func _ready() -> void:
	SignalBus.signal_start_game.connect(_start_game)
	SignalBus.signal_restart.connect(_restart_game)
	
	# Adds to score and prepares new round
	SignalBus.signal_scored.connect(_handle_score)


func _start_game():
	game_started = true


# Updates score and plays sounds
func _handle_score(scorer : String):
	match scorer:
		"Player":
			player_score += 1
			UiManager.sfx_player.stream = GameConstants.PLAYERSCORE_SFX
			UiManager.sfx_player.stop()
			UiManager.sfx_player.play()
		"CPU":
			cpu_score += 1
			UiManager.sfx_player.stream = GameConstants.CPUSCORE_SFX
			UiManager.sfx_player.stop()
			UiManager.sfx_player.play()
	game_started = false
	
	if player_score == GameConstants.MAX_SCORE || cpu_score == GameConstants.MAX_SCORE:
		SignalBus.signal_game_over.emit()
		game_over = true


# Restarts the game by resetting variables
func _restart_game():
	game_started = false
	game_over = false
	player_score = 0
	cpu_score = 0
	get_tree().reload_current_scene()
