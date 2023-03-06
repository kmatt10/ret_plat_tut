extends Area2D

const score_value = 1

onready var hitbox = $CollisionShape2D
enum Coinstate {FREE, GATHERED}
var coin_state = Coinstate.FREE


func _on_Coin_body_entered(body: Node) -> void:
	if body.name == "Ball":
		if body.is_free() && coin_state == Coinstate.FREE:
			coin_state = Coinstate.GATHERED
			$AnimatedSprite.play("pickup")
			$AudioStreamPlayer2D.play()
			Events.emit_signal("score_changed", score_value)


func _on_AudioStreamPlayer2D_finished():
	queue_free()
