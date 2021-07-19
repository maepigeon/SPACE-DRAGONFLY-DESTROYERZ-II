extends Node2D

export var projectile_scene : PackedScene

onready var firing_enabled : bool = true
var is_firing : bool = false
func fire():
	print("firing not implemented in gun"+name)
