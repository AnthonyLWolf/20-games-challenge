extends Node2D

@onready var background_parallax: Parallax2D = $BackgroundParallax
@onready var midground_parallax: Parallax2D = $MidgroundParallax
@onready var foreground_parallax: Parallax2D = $ForegroundParallax

@export var background_scroll_speed : float = 50.0
@export var midground_scroll_speed : float = 500.0
@export var foreground_scroll_speed : float = 1000.0

const SCROLL_LIMIT : float = 1600.0

var bg_start_scroll_pos_x : float
var mg_start_scroll_pos_x : float
var fg_start_scroll_pos_x : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg_start_scroll_pos_x = background_parallax.scroll_offset.x
	mg_start_scroll_pos_x = midground_parallax.scroll_offset.x
	fg_start_scroll_pos_x = foreground_parallax.scroll_offset.x
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	background_parallax.scroll_offset.x -= background_scroll_speed * delta
	midground_parallax.scroll_offset.x -= midground_scroll_speed * delta
	foreground_parallax.scroll_offset.x -= foreground_scroll_speed * delta
	
	if abs(background_parallax.scroll_offset.x) > abs(SCROLL_LIMIT):
		background_parallax.scroll_offset.x = abs(bg_start_scroll_pos_x)
	
	if abs(midground_parallax.scroll_offset.x) > abs(SCROLL_LIMIT):
		midground_parallax.scroll_offset.x = abs(mg_start_scroll_pos_x)
	
	if abs(foreground_parallax.scroll_offset.x) > abs(SCROLL_LIMIT):
		foreground_parallax.scroll_offset.x = abs(fg_start_scroll_pos_x)
