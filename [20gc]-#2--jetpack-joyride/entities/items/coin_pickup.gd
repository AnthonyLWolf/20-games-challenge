extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed : float = 500.0

const BASE_COIN_VALUE : int = 10

var coin_type : Array = ["Gold", "Silver", "Bronze"]
var texture : String
var start_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	start_position = global_position
	
	texture = coin_type.pick_random()
	
	match texture:
		"Gold":
			animated_sprite_2d.play("goldcoin")
		"Silver":
			animated_sprite_2d.play("silvercoin")
		"Bronze":
			animated_sprite_2d.play("bronzecoin")
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x -= speed * delta
	
	if global_position.x < -500:
		global_position = start_position
	
	#TODO: Return to pool when past the screen and rerun texture randomisation


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		#TODO: Return to pool
		var coins_to_add : int = BASE_COIN_VALUE
		match texture:
			"Gold":
				coins_to_add = BASE_COIN_VALUE * 10
			"Silver":
				coins_to_add = BASE_COIN_VALUE * 5
			"Bronze":
				coins_to_add = BASE_COIN_VALUE
		
		UiManager.coins += coins_to_add
		
		texture = coin_type.pick_random()
		
		match texture:
			"Gold":
				animated_sprite_2d.play("goldcoin")
			"Silver":
				animated_sprite_2d.play("silvercoin")
			"Bronze":
				animated_sprite_2d.play("bronzecoin")
		
		global_position = start_position
