extends Node2D

@export var profile : Weapon
var level : int = 0
var ammo : int = 0

var projectile_container : Node2D
var enemy_container : Node2D
var projectile = preload("res://Weapons/Projectile.tscn")
var random = RandomNumberGenerator.new()
@onready var player = get_parent().get_parent()
@onready var unload = $Unload
@onready var reload = $Reload

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	projectile_container = get_tree().get_root().get_node("Game").get_node("ProjectileContainer")
	enemy_container = get_tree().get_root().get_node("Game").get_node("EnemyContainer")
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
		instance.initial_velocity = player.velocity
		if profile.aim_type == 0:
			instance.direction = Vector2(0,1).rotated(spread*(i-1))
		if profile.aim_type == 1:
			var dir = player.input.normalized()
			if dir == Vector2.ZERO:
				dir = Vector2(0,1)
			instance.direction = dir.rotated(spread*i-spread_offset)
		if profile.aim_type == 2:
			var dir = global_position.direction_to(find_closest(global_position, enemy_container.get_children())-player.velocity/2)
			instance.direction = dir.rotated(spread*i-spread_offset)
		projectile_container.add_child.call_deferred(instance)

func upgrade():
	#spread
	profile.spread.x += profile.spread.y
	if profile.spread.x > 360:
		profile.spread.x = 360
	#multishot
	if profile.multishot.x < profile.spread.x/10:
		profile.multishot.x += profile.multishot.y
	else:
		profile.multishot.x = round(profile.spread.x/10)
		profile.damage.x += profile.multishot.y*profile.damage.y
	#damage
	profile.damage.x += profile.damage.y
	#ammo
	profile.ammo.x += profile.ammo.y
	#unload_time
	profile.unload_time.x += profile.unload_time.y
	if not profile.unload_time.x >= 0.05:
		profile.damage.x += 1
		profile.unload_time.x = 0.05
	#reload_time
	profile.reload_time.x += profile.reload_time.y
	if not profile.reload_time.x >= 0.05:
		profile.damage.x += 2
		profile.reload_time.x = 0.05
	#pierce
	profile.pierce.x += profile.pierce.y
	#speed
	profile.speed.x += profile.speed.y
	#scale
	profile.scale.x += profile.scale.y
	#timers
	reload.wait_time = profile.reload_time.x
	unload.wait_time = profile.unload_time.x
	ammo = round(profile.ammo.x)
	unload.start()
	#level
	level += 1

func find_closest(from : Vector2, selection : Array):
	var closest : Vector2 = selection[0].global_position
	for pos in selection:
		if from.distance_to(closest) > from.distance_to(pos.global_position):
			closest = pos.global_position
	return closest

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
