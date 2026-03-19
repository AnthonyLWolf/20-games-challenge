extends CharacterBody2D

@export var stats : EnemyStats = EnemyStats.new()

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
		SignalBus.signal_game_over.emit()
		print("Hit!")
