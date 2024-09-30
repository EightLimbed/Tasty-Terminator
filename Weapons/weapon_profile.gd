extends Resource

class_name Weapon

#load profiles to weapons

#stats

#aim type (0 for fixed, 1 for directional, 2 for autoaim)
@export var aim_type : int
#spread in degrees
@export var spread : int
#projectiles per shot
@export var multishot : int
#damage per projectile
@export var damage : int
#ammo before reload period
@export var ammo : int
#time between each shot in seconds
@export var unload_time : float
#time to reload in seconds
@export var reload_time : float
#pierce before destroying bullet(set to -1 for infinite)
@export var pierce : int
#speed (pixels per second)
@export var speed : int
#size of bullet hitbox
@export var hitbox_size : Vector2

#appearance
@export var projectile_frames : SpriteFrames
#trail
@export var trail : ParticleProcessMaterial
