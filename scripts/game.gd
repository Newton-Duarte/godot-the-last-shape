extends Node2D

@onready var game_over_canvas = $GameOverCanvas
@onready var victory_canvas = $VictoryCanvas
@onready var play_button = %PlayButton
@onready var quit_button = %QuitButton
@onready var victory_sfx = $VictorySFX
@onready var victory_play_button = %VictoryPlayButton
@onready var victory_menu_button = %VictoryMenuButton
@onready var victory_quit_button = %VictoryQuitButton

var targets_count := 0

func _ready():
	var targets = get_tree().get_first_node_in_group("Targets").get_children()
	targets_count = targets.size()

	for target in targets:
		if target.name != "Player":
			target.npc_died.connect(_on_npc_died)
	
	if !OS.has_feature("pc"):
		quit_button.hide()

func _on_play_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	get_tree().quit()
	
func _on_npc_died(npc):
	targets_count -= 1
	if (targets_count == 1):
		victory()

	print(str(targets_count) + " targets remaining")

func _on_player_player_died():
	game_over_canvas.show()
	play_button.grab_focus()
	get_tree().paused = true

func victory():
	victory_sfx.play()
	victory_canvas.show()
	victory_play_button.grab_focus()
	get_tree().paused = true


func _on_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
