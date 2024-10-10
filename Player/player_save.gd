extends Resource

#unlocked characters
@export var characters : Array
#unlocked maps
@export var maps : Array

#stats increased, can toggle on and off in menu

#increases max health. health regenerates 10% per second
@export var health_increase : int
#increases damage per bullet
@export var damage_increase : int
#increases movement speed
@export var speed_increase : int
#flat difficulty multiplier increase. harder enemies, but more xp
@export var hunger_increase : float
