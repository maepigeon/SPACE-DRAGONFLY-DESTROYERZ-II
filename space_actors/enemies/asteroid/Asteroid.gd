extends "res://space_actors/enemies/Enemy.gd"
class_name Asteroid
# An asteroid object that comes down from the sky.

export var speed : float = 128.0
export var direction := Vector2.DOWN 

# How much the asteroid spins.
var spin_amount_randomness_range : float = 1.0
var spin_amount : float

# The explosions particles scene.
var explosion_particles_scene := preload("res://space_actors/enemies/asteroid/ParticlesAsteroidExplosion.tscn")

var rng = RandomNumberGenerator.new()

# Run when the the Asteroid is instantiated.
func _ready() -> void:
	velocity = direction * speed
	rng.randomize()
	spin_amount = rng.randf_range(-spin_amount_randomness_range, spin_amount_randomness_range)
	spin_amount = spin_amount * spin_amount * min(1, max(-1, spin_amount)) * 5

# Runs on each frame.
func _physics_process(delta) -> void:
	position += velocity * delta
	rotation += PI * 0.5 * delta * spin_amount

# Code to make the asteroid explode
func explode() -> void:
	spawn_mini_asteroids(4)
	emit_explosion_particles()
	
# Call this function when the Actor exits the viewport.
func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	destroy()
	
	
# Emit explosion Particles
func emit_explosion_particles() -> void:
	var explosion_particles = explosion_particles_scene.instance()
	explosion_particles.position = self.position
	get_parent().add_child(explosion_particles)
	explosion_particles.emitting = true
	
# Spawns a bunch of small asteroids
func spawn_mini_asteroids(amount: int) -> void:
# warning-ignore:unused_variable
	for i in range(amount):
		spawn_mini_asteroid()
	
# Changes the direction of the asteroid.	
func change_direction(_speed : float, _direction : Vector2):
	speed = _speed
	direction = _direction
	set_velocity(speed * direction)
	

# Spawns a single mini-asteroid
func spawn_mini_asteroid() -> void:
	var mini_asteroid = load("res://space_actors/enemies/asteroid/SmallAsteroid.tscn").instance()
	randomize_trajectory(mini_asteroid)
	get_parent().add_child(mini_asteroid)
	mini_asteroid.position = position + mini_asteroid.direction * 30
	
# Randomizes the spin and direction of a spawned asteroid
func randomize_trajectory(asteroid : Node) -> void:
	var spawned_speed = rng.randf_range(60.0, 90.0)
	var dir = rng.randf_range(0, 360)
	
	asteroid.change_direction(spawned_speed, Vector2(cos(dir), sin(dir)))


# When the Actor dies, do this.
func _on_HPSystem_Dead() -> void:
	explode()
	CameraEffects.add_trauma(0.08)
	destroy()

# Whenever the Actor's HP is updated
func _on_HPSystem_HPUpdated(new_hp : float) -> void:
	$AnimatedSprite.modulate.g = new_hp / $HPSystem.max_hp
	$AnimatedSprite.modulate.b = new_hp / $HPSystem.max_hp
