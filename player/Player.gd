extends KinematicBody2D

export var move_speed := 100
export var gravity := 2000
export var jump_speed := 550

var velocity := Vector2.ZERO
onready var ball_obj := get_node("../Ball")

func _physics_process(delta: float) -> void:
	# reset horizontal velocity
	velocity.x = 0
	
	#---button actions---
	# set horizontal velocity
	if Input.is_action_pressed("move_right"):
		velocity.x += move_speed
	if Input.is_action_pressed("move_left"):
		velocity.x -= move_speed
	
	if Input.is_action_just_pressed("throw"):
		if !ball_obj.is_free():
			ball_obj.set_free()
	
	# apply gravity
	# player always has downward velocity
	velocity.y += gravity * delta
	
	# jump will happen on the next frame
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -jump_speed
	
	# actually move the player
	velocity = move_and_slide(velocity, Vector2.UP)

func _process(delta: float) -> void:
	change_animation()

func change_animation():
	#face left or right
	if velocity.x > 0:
		$AnimatedSprite.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite.flip_h = true
	
	if velocity.y < 0:
		$AnimatedSprite.play("jump")
	else:
		if velocity.x != 0:
			$AnimatedSprite.play("walk")
		else:
			$AnimatedSprite.play("idle")
