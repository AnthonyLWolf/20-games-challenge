extends CharacterBody2D

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var speed : float = 500.0
var direction : float = 0.0
var spawn_angle_y : float = 0.0
var dir : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.signal_ball_spawned.emit()
	
	dir = random_direction()
	
	velocity = dir * speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if !GameManager.game_started:
		return
	
	var collision = move_and_collide(velocity * delta)
	
	if not collision:
		return
	
	# Checks for collision and allows scoring if it's a left or right limit
	if collision:
		var collider 
		# Particles + sound
		cpu_particles_2d.restart()
		audio_stream_player.pitch_scale = randf_range(0.8, 1.5)
		audio_stream_player.stop()
		audio_stream_player.play(0.15)
		
		if collision.get_collider() is Paddle:
			collider = collision.get_collider()
			dir = new_direction(collider)
			velocity = dir * speed * ((GameConstants.BALL_ACCELERATION / 100) + 1)
		else:
			if collision.get_collider().is_in_group("score_limit"):
				if global_position.x > (GameManager.viewport_size.x / 2):
					SignalBus.signal_scored.emit("Player")
				elif global_position.x < (GameManager.viewport_size.x / 2):
					SignalBus.signal_scored.emit("CPU")
				SignalBus.signal_new_round.emit() # After score is updated, prepare a new round
				queue_free()
			else:
				velocity = velocity.bounce(collision.get_normal())


func random_direction():
	var new_dir := Vector2()
	new_dir.x = [1, -1].pick_random()
	new_dir.y = randf_range(-1, 1)
	return new_dir.normalized()


func new_direction(collider):
	var ball_y = global_position.y
	var pad_y = collider.global_position.y
	var dist = ball_y - pad_y
	var new_dir := Vector2()
	
	if dir.x > 0:
		new_dir.x = -1
	else:
		new_dir.x = 1
	new_dir.y = (dist / (collider.p_height / 2)) * GameConstants.MAX_BALL_Y_VECTOR
	return new_dir.normalized()
