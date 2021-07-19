extends Node

export var player1 : PackedScene = preload("res://space_actors/player/Player.tscn")
export var cursor : PackedScene = preload("res://ui/cursor/Cursor.tscn")

# O is WaveBase, positive are space_waves, negative are space_prototypes
export var wave : int = -1

func _ready():
	var player_1 : Node = player1.instance()
	var cursor_ : Node = cursor.instance()
	$Players.add_child(player_1)
	$Players.add_child(cursor_)
	player_1.position = Vector2(1920/2, 1080-100)
	
	# Create the wave
	var cur_wave : Node = get_node("Waves/Wave"+str(wave))
	cur_wave.start_wave($Enemies)
