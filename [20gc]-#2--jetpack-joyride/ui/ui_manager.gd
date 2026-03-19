extends Control

@onready var score_label: Label = $CanvasLayer/Control/Scores/ScoreLabel
@onready var coins_label: Label = $CanvasLayer/Control/Scores/HBoxContainer/CoinsLabel
@onready var leaderboard: CanvasLayer = $Leaderboard

#TODO: MOVE TO GAME MANAGER!!!
var score : float = 0.0 :
	set(new_score):
		score = snappedf(new_score, 0.01)
		score_label.text = str("Distance: ", score, "m")

var coins : int = 0 :
	set(new_coins):
		coins = new_coins
		coins_label.text = str(new_coins)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if leaderboard.visible:
		leaderboard.hide()
	score_label.text = str("Distance: ", score, "m")
	coins_label.text = str(coins)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
