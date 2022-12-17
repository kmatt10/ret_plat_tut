extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var ball_speed = 20

onready var velocity := (Vector2.UP + Vector2.RIGHT).normalized()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta * ball_speed)
	if collision:
		velocity = velocity.bounce(collision.normal)
		#if collision.collider.has_method("hit"):
		#	collision.collider.hit()
