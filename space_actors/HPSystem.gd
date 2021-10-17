extends Node
class_name HPSystem

# This is the hitpoint system used by all Actors.

# Actors cannot exceed their max_hp. They begin with max_hp.
export var max_hp : float = 3.0
export var immortal = false
export var hp_regen_rate : float = 0.0

onready var current_hp : float = max_hp

var alive : bool = true

signal Dead
signal HPUpdated
signal Damaged

# If HP doesn't regenerate, disable process() (where it heals).
func _ready():
	set_process(hp_regen_rate > 0.0)
	
# Sets the HP and max HP
func initialize_hp_and_max_hp(value : float) -> void:
	current_hp = value
	max_hp = value
	
# Updates the HP System's internal knowledge of if it is dead, and returns the 
# result.
func check_if_alive() -> bool:
	# If the Actor is immortal, it cannot die.
	if immortal:
		alive = true
		return true
	alive = current_hp > 0.0
	if not alive:
		emit_signal("Dead")
	return alive

# Heals the Actor a certain amount of hitpoints. Cannot deal damage or overheal.
func heal(amt : float):
	if alive:
		current_hp += max(0.0, amt)
		current_hp = min(current_hp, max_hp)
		emit_signal("HPUpdated", current_hp)

# Damages the Actor a certain amount of hitpoints. Cannot heal the Actor.
func damage(amt : float):
	# Don't kill the dead.
	if alive:
		current_hp -= max(amt, 0.0)
		emit_signal("HPUpdated", current_hp)
		emit_signal("Damaged", amt)
	check_if_alive()
	
# If the actor can regenerate HP, then heal it.
func _process(delta):
	heal(delta * hp_regen_rate)
