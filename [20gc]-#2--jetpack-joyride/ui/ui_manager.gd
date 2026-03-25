extends Control

@onready var score_label: Label = $CanvasLayer/Control/Scores/ScoreLabel
@onready var coins_label: Label = $CanvasLayer/Control/Scores/HBoxContainer/CoinsLabel
@onready var leaderboard: CanvasLayer = $Leaderboard


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if leaderboard.visible:
		leaderboard.hide()
	
	score_label.hide()
	coins_label.hide()
	score_label.text = str("Distance: ", GameManager.score, "m")
	coins_label.text = str(GameManager.coins)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
