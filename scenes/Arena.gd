extends Node

var player : PackedScene = preload("res://space_actors/player/Player.tscn")
export var cursor : PackedScene = preload("res://ui/cursor/Cursor.tscn")
export var number_of_players : int = 1
# O is WaveBase, positive are space_waves, negative are space_prototypes
export var wave : int = -1

func _ready():
	var player_1 : Node = player.instance()
	player_1.player_number = 1
	player_1.player_mode = "mouse"
	$Players.add_child(player_1)
	player_1.position = Vector2(1920/2, 1080-100)
	if number_of_players > 1:
		var player_2 : Node = player.instance()
		player_2.player_number = 2
		player_2.player_mode = "keyboard"
		$Players.add_child(player_2)
		player_2.position = Vector2(1920/2, 1080-100)
	
	var cursor_ : Node = cursor.instance()

	$Players.add_child(cursor_)

	
	# Create the wave
	var cur_wave : Node = get_node("Waves/Wave"+str(wave))
	cur_wave.start_wave($Enemies)
