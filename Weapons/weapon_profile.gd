extends Resource

class_name Weapon

#load profiles to weapons
@export var name : String
@export var display : Texture2D
@export var description : String

#stats, left is starting, right is increase every level

#aim type (0 for fixed, 1 for directional, 2 for autoaim)
@export var aim_type : int
#spread in degrees, between each bullet
@export var spread : Vector2
#projectiles per shot
@export var multishot : Vector2
#damage per projectile
@export var damage : Vector2
#ammo before reload period
@export var ammo : Vector2
#time between each shot in seconds
@export var unload_time : Vector2
#time to reload in seconds
@export var reload_time : Vector2
#pierce before destroying bullet(set to -1 for infinite)
@export var pierce : Vector2
#speed (pixels per second)
@export var speed : Vector2
#scale of bullet
@export var scale : Vector2
#ovverides lifetime of projectile when > 0
@export var lifetime_override : float
#appearance
@export var frames : SpriteFrames

#@export var sound
#size of bullet hitbox
@export var collision_shape : Shape2D
@export var collision_offset : Vector2
