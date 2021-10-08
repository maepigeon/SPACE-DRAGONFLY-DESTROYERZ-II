extends "res://space_actors/Actor.gd"

var explosion_particles_scene := preload("res://space_actors/enemies/asteroid/ParticlesAsteroidExplosion.tscn")

class_name Player

export var player_number = 1


# Speed contants
var keyboard_speed : float = 1400.0
var mouse_speed : float = 30000.0
var acceleration : float = 9000.0
var decelleration_speed = 15000.0

# Control inputs
var directional_input : Vector2
var action_just_pressed : bool
var escape_just_pressed : bool



var speed_dictionary : Dictionary = {
	"keyboard": keyboard_speed,
	"mouse": mouse_speed,
	"controller": mouse_speed
}

onready var current_max_speed : float = speed_dictionary[player_mode]

# Legal values: mouse, keyboard, controller
export var player_mode : String = "keyboard"

func _ready():
	if player_number == 1:
		InputManager.player1 = self
	elif player_number == 2:
		InputManager.player2 = self
	# Player loses control when they die, disable the cursor.
	$HPSystem.connect("Dead", InputManager, "_on_player_died")


func _process(delta : float) -> void:
	match player_mode:
		"keyboard", "controller":
			accelerate(delta)
			position += velocity * delta
		"mouse":
			velocity = directional_input * 0.2
			position += velocity
			
	position.x = clamp(position.x, 0, get_viewport_rect().size.x)
	position.y = clamp(position.y, 0, get_viewport_rect().size.y)
	$Gun.set_is_casting(action_just_pressed)
	

	
# Update velocity for frame
func accelerate(_delta : float) -> void:	
	# Handle accelleration
	# Accelerate faster if changing direction
	# Otherwise accelerate normally
	if same_sign(velocity.x, directional_input.x):
		velocity.x += _delta * acceleration * directional_input.x
	else:
		velocity.x += _delta * decelleration_speed * directional_input.x
	if same_sign(velocity.y, directional_input.y):
		velocity.y += _delta * acceleration * directional_input.y
	else:
		velocity.y += _delta * decelleration_speed * directional_input.y
	if velocity.length() > current_max_speed:
		velocity = velocity.normalized() * current_max_speed
		
	
	# Handle decelleration
	if velocity.x != 0.0 and directional_input.x == 0.0:
		var direction_x : int = 1 if velocity.x > 0 else -1
		velocity.x -= decelleration_speed * _delta * direction_x
		var new_direction_x : int = 1 if velocity.x > 0 else -1
		if new_direction_x != direction_x:
			velocity.x = 0.0
	if velocity.y != 0.0 and directional_input.y == 0.0:
		var direction_y : int = 1 if velocity.y > 0 else -1
		velocity.y -= decelleration_speed * _delta * direction_y
		var new_direction_y : int = 1 if velocity.y > 0 else -1
		if new_direction_y != direction_y:
			velocity.y = 0.0
			

# When the Player collides with another object
func handle_collision(body):
	if body.is_in_group("Enemies"):
		$HPSystem.damage(1.0)

# Compares the sign of two floats
func same_sign(var num1 : float, var num2 : float) -> bool:
	if num1 > 0 and num2 < 0:
		return false
	if num1 < 0 and num2 > 0:
		return false
	return true

# Whenever the Player's HP is updated
func _on_HPSystem_HPUpdated(new_hp : float) -> void:
	if new_hp <= 1.1:
		$AnimatedSprite.play("1hp")
	elif new_hp <= 2.1:
		$AnimatedSprite.play("2hp")
	else:
		$AnimatedSprite.play("3hp")	

# When the player is hurt.
func _on_HPSystem_Damaged(amount) -> void:
	CameraEffects.add_trauma(0.8)
	
# When the Player dies, do this.
func _on_HPSystem_Dead() -> void:
	emit_explosion_particles()
	destroy()


# Emit explosion Particles
func emit_explosion_particles() -> void:
	var explosion_particles = explosion_particles_scene.instance()
	explosion_particles.position = self.position
	get_parent().add_child(explosion_particles)
	explosion_particles.emitting = true
