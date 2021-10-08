extends Enemy
class_name Fly
# Run when the the Fly Fighter is instantiated.

export var speed : float = 1000.0
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var home_position : Vector2 = Vector2.ZERO
# The explosions particles scene.
var explosion_particles_scene := preload("res://space_actors/enemies/fly/ParticlesFlyExplosion.tscn")
var direction = Vector2.DOWN


func _ready() -> void:
	velocity = Vector2.DOWN * speed
	rng.randomize()
	$AnimationPlayer.play("default")
	
# Runs on each frame.
func _physics_process(delta) -> void:
	zigzag_motion(delta)
	

# zigzag_duration is the rate the zigzag changes direction
var zigzag_duration : float = 1
# zigzag_amount is the magnitude ofthe zigzag
var zigzag_amount : float = 300
var zigzag_time : float = 0.0
# Handles ZigZag motion when in the zigzag state
func zigzag_motion(delta : float) -> void:
	zigzag_time += delta / zigzag_duration
	var zigzag_direction : float = 0
	if sin(zigzag_time * 2 * PI) > 0:
		zigzag_direction = 1
	else:
		zigzag_direction= -1
	velocity = Vector2(zigzag_direction * zigzag_amount, speed)
		

	position += velocity * delta

# Bugs out the Fly's eyes, from 0 (normal) to 3 (about to die)
func bug_out_eyes(amt : float = 0):
	$LeftEye.scale = Vector2(1, 1) * amt
	$RightEye.scale = Vector2(1, 1) * amt
	
# Code to make the asteroid explode
func explode() -> void:
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

# When the Actor dies, do this.
func _on_HPSystem_Dead() -> void:
	explode()
	CameraEffects.add_trauma(0.08)
	destroy()

# Whenever the Actor's HP is updated
func _on_HPSystem_HPUpdated(new_hp : float) -> void:
	$AnimatedSprite.modulate.g = new_hp / $HPSystem.max_hp
	$AnimatedSprite.modulate.b = new_hp / $HPSystem.max_hp
	bug_out_eyes(0.75 - (0.25 * new_hp / $HPSystem.max_hp))
	scale = Vector2(1, 1) * (1.5 - (0.5 * new_hp / $HPSystem.max_hp))
