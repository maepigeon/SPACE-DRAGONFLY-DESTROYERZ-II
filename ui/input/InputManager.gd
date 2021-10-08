extends Node2D

var player1 : Node
var player2 : Node
var cursor : Node 


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	process_priority = 0
	
func _process(delta):
	handle_player_input(player1)
	if player2:
		handle_player_input(player2)
	
# When the player dies, make the cursor not visible.
func _on_player_died() -> void:
	show_cursor(false)
	
func show_cursor(cursor_visible) -> void:
	cursor.set_enabled(cursor_visible)
	
# Manages input for the specified Player.
func handle_player_input(player: Node) -> void:
	if player:
		player.directional_input = Vector2.ZERO
		player.action_just_pressed = false
		player.escape_just_pressed = false
	if Input.is_action_pressed("ui_cancel"):
		if player:
			player.escape_just_pressed = true
		get_tree().quit()
	
	if !player:
		return
			
	if Input.is_action_just_pressed("x"):
		if player.player_mode == "mouse":
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			player.player_mode = "keyboard"
			if cursor:
				cursor.position = self.get_global_mouse_position()
				show_cursor(false)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			player.player_mode = "mouse"
			if cursor:
				show_cursor(true)
	
	match player.player_mode:
		"mouse":
			cursor.position = self.get_global_mouse_position()
			player.directional_input = get_global_mouse_position() - player1.position
			if Input.is_mouse_button_pressed(1):
				cursor.set_is_shooting(true)
				player.action_just_pressed = true
			else:
				cursor.set_is_shooting(false)
		"controller":
			pass
		"keyboard":
			if Input.is_action_pressed("ui_right"):
				player.directional_input.x += 1
			if Input.is_action_pressed("ui_left"):
				player.directional_input.x -= 1
			if Input.is_action_pressed("ui_up"):
				player.directional_input.y -= 1
			if Input.is_action_pressed("ui_down"):
				player.directional_input.y += 1
			if Input.is_action_pressed("ui_accept"):
				player.action_just_pressed = true
			player.directional_input = player.directional_input.normalized()
		
