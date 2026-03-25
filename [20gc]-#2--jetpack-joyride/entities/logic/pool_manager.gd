extends Node2D

@onready var coin_pool : Node2D = Node2D.new()
@onready var obstacles_pool : Node2D = Node2D.new()
@onready var coin_timer_cooldown: Timer = $CoinTimerCooldown
@onready var coin_timer_spawn: Timer = $CoinTimerSpawn
@onready var obstacle_timer_spawn: Timer = $ObstacleTimerSpawn


const COIN_SCENE = preload("res://entities/items/coin_pickup.tscn")
const BEE_SCENE = preload("res://entities/obstacles/bee/obstacle_bee.tscn")
const SLIME_SCENE = preload("res://entities/obstacles/slime/obstacle_slime.tscn")

var available_pool = {
	"obstacles": [],
	"coins": [],
}
var cooldown_pool = {
	"obstacles": [],
	"coins": [],
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connects signals
	SignalBus.signal_recycle_coin.connect(func(coin : Node2D): cooldown_pool["coins"].append(coin))
	SignalBus.signal_recycle_entity.connect(func(entity : Node2D): cooldown_pool["obstacles"].append(entity))
	
	# Creates pools
	_setup_pools()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _setup_pools() -> void:
	# Sets up coin pool
	coin_pool.name = "CoinPool"
	add_child(coin_pool)
	
	var coin_index = 1
	# Instantiate coins inside pool
	for coin in range(GameConstants.MAX_COIN_POOL_SIZE):
		var instance = COIN_SCENE.instantiate()
		instance.name = str("Coin", coin_index)
		coin_pool.add_child(instance)
		available_pool["coins"].append(instance)
		coin_index += 1
		
	# Sets up obstacles pool
	obstacles_pool.name = "ObstaclesPool"
	add_child(obstacles_pool)
	
	var bee_index = 1
	# Instantiate bees inside pool
	for bee in range(GameConstants.MAX_ENTITIES_POOL_SIZE / 2):
		var instance = BEE_SCENE.instantiate()
		instance.name = str("Bee", bee_index)
		obstacles_pool.add_child(instance)
		available_pool["obstacles"].append(instance)
		bee_index += 1
		
	var slime_index = 1
	# Instantiate bees inside pool
	for slime in range(GameConstants.MAX_ENTITIES_POOL_SIZE / 2):
		var instance = SLIME_SCENE.instantiate()
		instance.name = str("Slime", slime_index)
		obstacles_pool.add_child(instance)
		available_pool["obstacles"].append(instance)
		slime_index += 1
		
	for obstacle in available_pool["obstacles"]:
		obstacle.global_position.x = GameManager.screen_width + 5000



## Spawn a coin from the available coins pool and pops it off the array
func _spawn_coin() -> void:
	# Grab a coin from the pool and spawn it
	if available_pool["coins"].size() > 0:
		var coin_to_spawn = available_pool["coins"].pop_front()
		if coin_to_spawn:
			coin_to_spawn.spawn()
			


## Spawns an obstacle from the available pool and pops it off the array
func _spawn_obstacle():
	if available_pool["obstacles"].size() > 0:
		available_pool["obstacles"].shuffle()
		var obstacle_to_spawn = available_pool["obstacles"].pop_front()
		if obstacle_to_spawn:
			obstacle_to_spawn.spawn()


## Move a coin from the front of the cooldown queue to the back of the available pool
func _on_coin_timer_cooldown_timeout() -> void:
	if cooldown_pool["coins"].size() > 0:
		var c = cooldown_pool["coins"].pop_front()
		if c && available_pool["coins"].size() < GameConstants.MAX_COIN_POOL_SIZE:
			available_pool["coins"].append(c)


func _on_coin_timer_spawn_timeout() -> void:
	coin_timer_spawn.wait_time = randf_range(0.1, 1.5)
	_spawn_coin()


func _on_obstacle_timer_cooldown_timeout() -> void:
	if cooldown_pool["obstacles"].size() > 0:
		var o = cooldown_pool["obstacles"].pop_front()
		if o && available_pool["obstacles"].size() < GameConstants.MAX_ENTITIES_POOL_SIZE:
			available_pool["obstacles"].append(o)


func _on_obstacle_timer_spawn_timeout() -> void:
	obstacle_timer_spawn.wait_time = randf_range(1.0, 2.0)
	_spawn_obstacle()
	
