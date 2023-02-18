extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ball_speed = 200
var in_collision = false
enum BallState  { FREE, CAUGHT }

export (BallState) var ball_state = BallState.CAUGHT
var can_collide_w_player = false

onready var velocity := (Vector2.UP + Vector2.RIGHT).normalized()
onready var player_obj := get_node("../Player")
onready var ball_hitbox := get_node("CollisionShape2D")
onready var catch_hitbox := get_node("CatchArea/CollisionShape2D")
onready var ball_line := get_node("Line2D")
onready var sprite_obj := get_node("Sprite")

func is_free():
	return ball_state == BallState.FREE

func set_free():
	if in_collision:
		pass
	else:
		velocity = player_obj.get_aim()
		ball_hitbox.set_deferred("disabled",false)
		catch_hitbox.set_deferred("disabled",false)
		can_collide_w_player = false
		ball_state = BallState.FREE
	
func set_caught():
	ball_hitbox.set_deferred("disabled",true)
	catch_hitbox.set_deferred("disabled",true)
	ball_state = BallState.CAUGHT

# Called when the node enters the scene tree for the first time.
func _ready():
	set_caught()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_free():
		var collision = move_and_collide(velocity * delta * ball_speed)
		if collision:
			if collision.collider.name == "Player":
				if can_collide_w_player:
					set_caught()
			elif collision.collider.name == "Coin":
				pass
			else:
				can_collide_w_player = true
			velocity = velocity.bounce(collision.normal)
			
func _process(_delta):
	if !is_free():
		position.x = player_obj.position.x
		position.y = player_obj.position.y - 20
		
		var mouse_coords = get_local_mouse_position()
		
		ball_line.set_point_position(0,sprite_obj.position)
		ball_line.set_point_position(1,mouse_coords)
	
	
	if is_free():
		ball_line.visible = false
	else:
		ball_line.visible = true


func _on_CatchArea_body_entered(body):
	if body.name == "Player" and can_collide_w_player:
		set_caught()

func _on_platform_interior_area_entered(body):
	print(body.name + "ENTER")
	if body.name == "Ball":
		in_collision = true

func _on_platform_interior_area_exited(body):
	print(body.name + "EXIT")
	if body.name == "Ball":
		in_collision = false
