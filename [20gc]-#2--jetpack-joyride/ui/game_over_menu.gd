extends Control

@onready var score_label: Label = $Control/VBoxContainer/ScoreLabel
@onready var coin_label: Label = $Control/VBoxContainer/CoinLabel
@onready var peak_music_player: AudioStreamPlayer = $PeakMusicPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_label.text = str("You ran for ", GameManager.score, "m")
	coin_label.text = str("Score: ", GameManager.coins)
	if !peak_music_player.playing:
		peak_music_player.play(84.5)


func _on_restart_button_pressed() -> void:
	SignalBus.signal_start_game.emit()
	get_tree().change_scene_to_file("res://levels/main.tscn")


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
