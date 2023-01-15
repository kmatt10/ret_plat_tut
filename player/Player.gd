extends KinematicBody2D

export var move_speed := 100
export var MAX_SPEED := 300
export var acceleration := 100
export var gravity := 2000
export var friction := .2
export var jump_speed := 550

var velocity := Vector2.ZERO
var launch_vec := (Vector2.UP + Vector2.RIGHT).normalized()
onready var ball_obj := get_node("../Ball")
onready var line_obj := get_node("Aim")

func get_aim():
	return launch_vec.normalized()

func _physics_process(delta: float) -> void:
	#TODO: Add momentum to movement
	
	#---button actions---
	# set horizontal velocity
	if Input.is_action_pressed("move_right"):
		if velocity.x < MAX_SPEED:
			velocity.x += acceleration
	if Input.is_action_pressed("move_left"):
		if velocity.x > -MAX_SPEED:
			velocity.x -= acceleration
	# set launch angle
	if Input.is_action_pressed("aim_right"):
		launch_vec = (launch_vec + Vector2.RIGHT*2).normalized()
	if Input.is_action_pressed("aim_up"):
		launch_vec = (launch_vec + Vector2.UP).normalized()
	if Input.is_action_pressed("aim_left"):
		launch_vec = (launch_vec + Vector2.LEFT*2).normalized()
	
	if Input.is_action_just_pressed("throw"):
		if !ball_obj.is_free():
			ball_obj.set_free()
		else:
			ball_obj.set_caught()
	
	# apply gravity
	# player always has downward velocity
	velocity.y += gravity * delta
	
	# apply friction
	if is_on_floor():
		velocity.x = lerp(velocity.x,0,friction)
	
	# jump will happen on the next frame
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -jump_speed
	
	# actually move the player
	velocity = move_and_slide(velocity, Vector2.UP)

func _process(delta: float) -> void:
	change_animation()
	
	# mouse aiming
	var ball_sprite = ball_obj.get_node("Sprite")
	var ball_line = ball_obj.get_node("Line2D")
	var mouse_coords = ball_sprite.get_local_mouse_position()
	var sprite_coords = Vector2(ball_sprite.position.x, ball_sprite.position.y - 20)
	launch_vec = Vector2(mouse_coords.x - sprite_coords.x, mouse_coords.y - sprite_coords.y).normalized()
	
	#set debug line
	line_obj.set_point_position(0,sprite_coords)
	line_obj.set_point_position(1,mouse_coords)
	
	
	if ball_obj.is_free():
		line_obj.visible = false
	else:
		line_obj.visible = true

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
