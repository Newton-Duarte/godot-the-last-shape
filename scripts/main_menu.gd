extends Node2D


@onready var play_button = %PlayButton
@onready var credits_button = %CreditsButton
@onready var quit_button = %QuitButton
@onready var credits_panel = %CreditsPanel
@onready var close_credits_button = %CloseCreditsButton

func _ready():
	play_button.grab_focus()
	
	if !OS.has_feature("pc"):
		quit_button.hide()

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_credits_panel_toggle():
	credits_panel.visible = !credits_panel.visible
	if credits_panel.visible:
		close_credits_button.grab_focus()
	else:
		play_button.grab_focus()


func _on_quit_button_pressed():
	get_tree().quit()
