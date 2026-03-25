extends CanvasLayer

@onready var leaderboard_container: VBoxContainer = $LeaderboardControl/Panel/LeaderboardContainer

# Local storage
var lb_stored_data : Array = []

# Data set for testing
var test_set : Array = [252.0, 111.0, 123.2, 50.5, 200.0]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Saves score to file and updates leaderboard whenever hero goes on game over 
	SignalBus.signal_new_score.connect(func():
		_save_to_file(GameConstants.LB_PATH, GameManager.score)
		_update_leaderboard()
		)
	
	for child in leaderboard_container.get_children():
		if child is HBoxContainer:
			var score_label = child.find_child("ScoreLabel")
			score_label.text = "N/A"
	
	# Checks existence of file before loading the leaderboard
	if _leaderboard_file_exists(GameConstants.LB_PATH):
		lb_stored_data = _load_from_file(GameConstants.LB_PATH)
		
		#TODO: For testing, remove before deploying
		#for line in test_set:
			#_save_to_file(GameConstants.LB_PATH, line)
		
		# Updates the leaderboard with the currently stored file
		_update_leaderboard()
	else:
		var file = FileAccess.open(GameConstants.LB_PATH, FileAccess.WRITE)
		file.store_string("")
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _leaderboard_file_exists(path_to_file : String) -> bool:
	var file = FileAccess.open(path_to_file, FileAccess.READ)
	if file:
		return true
	
	return false


func _update_leaderboard() -> void:
	
	# Grabs the score labels of each rank, compares their index to the current value in the leaderboard file, and updates as needed
	for child in leaderboard_container.get_children():
		var data_i : int = 0
		if child is HBoxContainer:
			var score_label = child.find_child("ScoreLabel")
			for line in lb_stored_data:
				if data_i == child.get_index():
					score_label.text = str(line, "m")
				data_i += 1

# Handles file saving by comparing current file contents to the scores to add
func _save_to_file(path_to_file : String, new_score : float) -> void:
	var loaded_data = lb_stored_data # Stores the contents of the file for sorting and saving
	
	# Appends the score to the list if the size is smaller than the max allowed, and if there's no duplicate
	if loaded_data.size() < GameConstants.MAX_SCORE_SLOTS:
		if not loaded_data.has(new_score):
			loaded_data.append(new_score)

	# Sorts data in reverse order
	loaded_data.sort()
	loaded_data.reverse()
	lb_stored_data = loaded_data.slice(0, GameConstants.MAX_SCORE_SLOTS - 1)
	
	# Writes to file
	var file = FileAccess.open(path_to_file, FileAccess.WRITE)
	for score in lb_stored_data:
		file.store_line(str(score))
	file.close()


# Returns an array with the contents of the loaded file
func _load_from_file(path_to_file : String) -> Array:
	var file = FileAccess.open(path_to_file, FileAccess.READ)
	var data : Array = []
	
	if !file:
		return data
	
	while !file.eof_reached():
		var line = file.get_line().strip_edges()
		if line != "":
			data.append(float(line))
	
	data.sort()
	data.reverse()
	return data


func _on_main_menu_button_pressed() -> void:
	hide()
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
