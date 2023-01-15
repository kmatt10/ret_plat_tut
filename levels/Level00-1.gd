extends Node2D

onready var tip_text = $CanvasLayer/HUD/MarginContainer/HBoxContainer/LevelTips

func _ready():
	tip_text.text = """Catch the ball by making contact with it in flight"""
