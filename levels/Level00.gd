extends Node2D


onready var tip_text = $CanvasLayer/HUD/MarginContainer/HBoxContainer/LevelTips


func _ready():
	tip_text.text = """Throw the ball to collect the coins
	Try to catch them all in as few throws as possible"""
