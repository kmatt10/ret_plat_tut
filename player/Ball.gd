extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var ball_speed = 20
enum BallState  { FREE, CAUGHT }

export (BallState) var ball_state = BallState.FREE

onready var velocity := (Vector2.UP + Vector2.RIGHT).normalized()
onready var player_obj := get_node("../Player")

func is_free():
	return ball_state == BallState.FREE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_free():
		var collision = move_and_collide(velocity * delta * ball_speed)
		if collision:
			if collision.collider.name == "Player":
				ball_state = BallState.CAUGHT
			velocity = velocity.bounce(collision.normal)
			#if collision.collider.has_method("hit"):
			#	collision.collider.hit()
			
func _process(delta):
	if !is_free():
		position.x = player_obj.position.x + 20
		position.y = player_obj.position.y - 10
