extends CharacterBody2D

@onready var game_over_sfx_player: AudioStreamPlayer = $GameOverSFXPlayer

@export var stats : EnemyStats = EnemyStats.new()

var spawn_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if !is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity = velocity.move_toward(Vector2.LEFT * stats.speed, stats.acceleration * delta)
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if !game_over_sfx_player.playing:
			game_over_sfx_player.play()
		SignalBus.signal_game_over.emit()
		print("Hit!")


## Spawns the entity to the edge of the screen
func spawn() -> void:
	# Spawns the slime inside the screen rect
	spawn_position = Vector2(GameManager.screen_width -2, get_viewport_rect().size.y - 50)
	global_position = spawn_position


# Returns the entity to the pool
func recycle() -> void:
	global_position.x = GameManager.screen_width + 300
	SignalBus.signal_recycle_entity.emit(self)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	set_physics_process(true)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	recycle()
	set_physics_process(false)
