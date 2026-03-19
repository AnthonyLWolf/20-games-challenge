class_name Player
extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $HeroSprite
@onready var jetpack_sprite: AnimatedSprite2D = $JetpackSprite


@export var fly_speed : float = 1000.0
@export var falling_speed : float = 1.2

var is_jumping : bool = false


enum State {
	IDLE,
	RUNNING,
	FLYING,
	DEAD
}
var previous_state : State
var current_state : State = State.IDLE :
	set(new_state):
		previous_state = current_state
		current_state = new_state


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	UiManager.score += delta
	
	if !is_on_floor():
		velocity += get_gravity() * delta * falling_speed
		current_state = State.FLYING
		
	if is_on_floor():
		current_state = State.RUNNING
	
	_handle_animations()
	_handle_input(delta)
	
	move_and_slide()


func _handle_animations() -> void:
	match current_state:
		State.RUNNING:
			if is_on_floor() && !animated_sprite_2d.is_playing():
				is_jumping = false
				animated_sprite_2d.play("run")
				jetpack_sprite.play("run")
		State.FLYING:
			jetpack_sprite.play("fly")
			if !is_on_floor() && !is_jumping:
				animated_sprite_2d.play("fly")
				is_jumping = true


func _handle_input(delta : float) -> void:
	if Input.is_action_pressed("fly"):
		velocity.y -= fly_speed * delta

# On game over, emit signal that sends path to save file and current score to update the leaderboard
func _game_over() -> void:
	SignalBus.signal_new_score.emit(GameConstants.LB_PATH, UiManager.score)
