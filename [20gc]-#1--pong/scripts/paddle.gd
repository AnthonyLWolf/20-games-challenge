class_name Paddle
extends AnimatableBody2D

@onready var color_rect: ColorRect = $"../Control/ColorRect"
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var speed : float = 10.0
@export var cpu_speed : float = 3300.0
@export_enum("Player", "CPU") var paddle_type : String

var start_pos : Vector2
var p_height : float = 0.0
var ball = null
var ball_dist : float = 0.0
var move_by : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_pos = global_position
	
	# Sets up CPU which should have been separate anyway ffs
	if paddle_type == "CPU":
		SignalBus.signal_start_game.connect(func(): global_position = start_pos)
		SignalBus.signal_ball_spawned.connect(func(): ball = get_tree().get_first_node_in_group("ball"))
	
	# Calculates paddle height for later calculations
	p_height = collision_shape_2d.shape.get_rect().size.y


# Handles input depending on paddle type
func _input(event: InputEvent) -> void:
	match paddle_type:
		"Player":
			if event is InputEventMouseMotion:
				global_position.y = clamp(event.position.y, p_height / 2, GameManager.viewport_size.y - p_height / 2)
			
			if event is InputEventKey:
				if event.is_action_pressed("down", true):
					global_position.y += speed
				if event.is_action_pressed("up", true):
					global_position.y -= speed
		"CPU":
			#TODO: Implementing two-player mode would be cool!
			if event is InputEventKey:
				if event.is_action_pressed("down_cpu", true):
					global_position.y += speed
				if event.is_action_pressed("up_cpu", true):
					global_position.y -= speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if paddle_type != "CPU" || !ball:
		return
	
	# Calculates distance from ball to handle movement
	ball_dist = global_position.y - ball.global_position.y
	
	# Moves paddle based on ball distance
	if ball.global_position.x > GameManager.viewport_size.x / 2:
		if abs(ball_dist) > cpu_speed * delta:
			move_by = cpu_speed * delta * (ball_dist / abs(ball_dist)) # NOTE: Divide a value by its absolute value and you'll always get a positive 
		else:
			move_by = ball_dist
		
		# Limit paddle movement to screen size
		global_position.y = clamp(global_position.y - move_by, p_height / 2, GameManager.viewport_size.y - p_height / 2)
