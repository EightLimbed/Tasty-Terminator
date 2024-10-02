extends Node2D

var profile : Weapon
var level : int = 0
var ammo : int = 0

var projectile_container
var projectile = preload("res://Weapons/Projectile.tscn")
var random = RandomNumberGenerator.new()
@onready var player = get_parent().get_parent()
@onready var unload = $Unload
@onready var reload = $Reload

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	profile = load("res://Weapons/Resources/ChocolateChips.tres")
	projectile_container = get_tree().get_root().get_node("Game").get_node("ProjectileContainer")
	reload.wait_time = profile.reload_time.x
	unload.wait_time = profile.unload_time.x
	reload.start()

#need to add collision layers
func shoot():
	var spread = deg_to_rad(profile.spread.x)/round(profile.multishot.x)
	var spread_offset = deg_to_rad(profile.spread.x/2)
	for i in round(profile.multishot.x):
		var instance = projectile.instantiate()
		instance.global_position = global_position
		#instance.collision_layer = 4
		instance.scale.x = profile.scale.x
		instance.scale.y = profile.scale.x
		instance.frames = profile.texture
		instance.speed = profile.speed.x
		instance.pierce = profile.pierce.x
		instance.damage = profile.damage.x
		instance.collision_shape = profile.collision_shape
		if profile.aim_type == 0:
			instance.direction = Vector2(0,1).rotated(spread*(i-1))
		if profile.aim_type == 1:
			var dir = player.input.normalized()
			if dir == Vector2.ZERO:
				dir = Vector2(0,1)
			instance.direction = dir.rotated(spread*i-spread_offset)
		if profile.aim_type == 2:
			instance.direction = Vector2(0,-1).rotated(spread*i-spread_offset)
		projectile_container.add_child.call_deferred(instance)

func upgrade():
	#spread
	profile.spread.x += profile.spread.y
	if profile.spread.x > 360:
		profile.spread.x = 360
	#multishot
	profile.multishot.x += profile.multishot.y
	#damage
	profile.damage.x += profile.damage.y
	#ammo
	profile.ammo.x += profile.ammo.y
	#unload_time
	profile.unload_time.x += profile.unload_time.y
	#reload_time
	profile.reload_time.x += profile.reload_time.y
	#pierce
	profile.pierce.x += profile.pierce.y
	#speed
	profile.speed.x += profile.speed.y
	#scale
	profile.scale.x += profile.scale.y
	#timers
	if profile.reload_time.x > 0:
		reload.wait_time = profile.reload_time.x
	if profile.unload_time.x > 0:
		unload.wait_time = profile.unload_time.x
	ammo = round(profile.ammo.x)
	unload.start()
	#level
	level += 1

func _on_unload_timeout() -> void:
	if ammo > 0:
		shoot()
		ammo -= 1
		unload.start()
	else:
		reload.start()

func _on_reload_timeout() -> void:
	ammo = round(profile.ammo.x)
	unload.start()
