extends Area2D

const score_value = 1


func _on_Coin_body_entered(body: Node) -> void:
	if body.name == "Ball":
		if body.is_free():
			$AnimatedSprite.play("pickup")
			$AudioStreamPlayer2D.play()
			Events.emit_signal("score_changed", score_value)


func _on_AudioStreamPlayer2D_finished():
	queue_free()
