extends Node

@onready var screen_width : int = get_viewport().size.x

var score : float = 0.0 :
	set(new_score):
		score = snappedf(new_score, 0.01)
		UiManager.score_label.text = str("Distance: ", score, "m")

var coins : int = 0 :
	set(new_coins):
		coins = new_coins
		UiManager.coins_label.text = str(new_coins)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.signal_start_game.connect(func():
		Engine.time_scale = 1.0
		UiManager.score_label.show()
		UiManager.coins_label.show()
		score = 0.0
	)
	SignalBus.signal_game_over.connect(func():
		Engine.time_scale = 0.1
		await get_tree().create_timer(1.5, true, false, true).timeout
		Engine.time_scale = 0.0
		UiManager.score_label.hide()
		UiManager.coins_label.hide()
		SignalBus.signal_new_score.emit()
		get_tree().change_scene_to_file("res://ui/game_over_menu.tscn")
	)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
