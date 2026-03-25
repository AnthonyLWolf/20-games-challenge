extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var pool_manager : Node2D = get_parent().get_parent()
@onready var pickup_sfx_player: AudioStreamPlayer = $PickupSFXPlayer

@export var speed : float = 500.0

const COIN_SFX = preload("uid://khvuvapta77c")
const GOLD_COIN_SFX = preload("uid://j5j1s3w2iwvm")

const BASE_COIN_VALUE : int = 10

var coin_type : Array = ["Gold", "Silver", "Bronze"]
var texture : String
var spawn_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x -= speed * delta


## Spawns the coin to a random vertical position
func spawn() -> void:
	show()
	
	# Picks a random coin type
	texture = coin_type.pick_random()
	match texture:
		"Gold":
			animated_sprite_2d.play("goldcoin")
		"Silver":
			animated_sprite_2d.play("silvercoin")
		"Bronze":
			animated_sprite_2d.play("bronzecoin")
	
	# Spawns the coin inside the screen rect
	spawn_position.x = GameManager.screen_width - 2
	spawn_position.y = randf_range(get_viewport_rect().size.y - 200, 150)
	global_position = spawn_position


# Returns the coin to the pool
func recycle() -> void:
	global_position.x = GameManager.screen_width + 300
	SignalBus.signal_recycle_coin.emit(self)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if pickup_sfx_player.playing:
			pickup_sfx_player.stop()
		hide()
		
		var coins_to_add : int = BASE_COIN_VALUE
		match texture:
			"Gold":
				coins_to_add = BASE_COIN_VALUE * 10
				pickup_sfx_player.stream = GOLD_COIN_SFX
				pickup_sfx_player.play()
			"Silver":
				coins_to_add = BASE_COIN_VALUE * 5
				pickup_sfx_player.stream = COIN_SFX
				pickup_sfx_player.play()
			"Bronze":
				coins_to_add = BASE_COIN_VALUE
				pickup_sfx_player.stream = COIN_SFX
				pickup_sfx_player.play()
		
		GameManager.coins += coins_to_add


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	set_process(true)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	recycle()
	set_process(false)
