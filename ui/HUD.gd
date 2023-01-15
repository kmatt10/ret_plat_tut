extends Control

onready var label = $MarginContainer/VBoxContainer/HBoxContainer/ScoreLabel
onready var complete = $MarginContainer/VBoxContainer/HBoxContainer2/CompleteLabel
onready var throws = $MarginContainer/VBoxContainer/HBoxContainer3/ThrowCount

var score = 0
export var score_limit = 5
var throw_count = 0
export var next_level = "01"

func _ready() -> void:
	label.text = str(score) + "/" + str(score_limit)
	throws.text = "Throws: " + str(throw_count)
	complete.visible = false
	
func _enter_tree() -> void:
	Events.connect("score_changed", self, "_on_score_changed") 
	Events.connect("ball_thrown", self, "_on_ball_thrown")
	
func _exit_tree() -> void:
	Events.disconnect("score_changed", self, "_on_score_changed") 
	Events.disconnect("ball_thrown", self, "_on_ball_thrown")
	
func _process(delta):
	if Input.is_action_just_pressed("confirm"):
		if score == score_limit:
			print("load the next level :)")
			get_tree().change_scene("res://levels/Level" + next_level + ".tscn")

func _on_score_changed(value):
	score += value
	if score == score_limit:
		complete.visible = true
	label.text = str(score) + "/" + str(score_limit)

func _on_ball_thrown():
	throw_count += 1
	throws.text = "Throws: " + str(throw_count)
