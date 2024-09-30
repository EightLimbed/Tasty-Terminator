extends Resource

class_name Weapon

#load profiles to weapons

#stats, left is starting, right is final

#aim type (0 for fixed, 1 for directional, 2 for autoaim)
@export var aim_type : int
#spread in degrees, between each bullet
@export var spread : Vector2i
#projectiles per shot
@export var multishot : Vector2i
#damage per projectile
@export var damage : Vector2i
#ammo before reload period
@export var ammo : Vector2i
#time between each shot in seconds
@export var unload_time : Vector2
#time to reload in seconds
@export var reload_time : Vector2
#pierce before destroying bullet(set to -1 for infinite)
@export var pierce : Vector2i
#speed (pixels per second)
@export var speed : Vector2i
#size of bullet hitbox
@export var hitbox_size : Vector2

#appearance
@export var projectile_frames : SpriteFrames
#trail
@export var trail : ParticleProcessMaterial
