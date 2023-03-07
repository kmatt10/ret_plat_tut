extends Node2D

onready var pixel_ref = $TileMap
onready var timer_ref = $Appearance

export var CLOCK_TIME = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	timer_ref.set_deferred("wait_time", CLOCK_TIME)
	timer_ref.start()

func _on_Appearance_timeout():
	toggle_bumper()

func toggle_bumper() -> void:
	pixel_ref.visible = !pixel_ref.visible
	if pixel_ref.visible:
		pixel_ref.collision_layer = 1
		pixel_ref.collision_mask = 1
	else:
		pixel_ref.collision_layer = 2
		pixel_ref.collision_mask = 2
