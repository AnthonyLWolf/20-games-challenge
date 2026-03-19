extends Control

@onready var score_label: Label = $CanvasLayer/Control/Scores/ScoreLabel

#TODO: MOVE TO GAME MANAGER!!!
var score : float = 0.0 :
	set(new_score):
		score = snappedf(new_score, 0.01)
		score_label.text = str("Distance: ", score, "m")
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_label.text = str("Distance: ", score, "m")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
