extends Node2D

@export var profile : Weapon
var ammo : int = 0

@onready var projectile_container = get_tree().get_root().get_node("Game").get_node("ProjectileContainer")
@onready var enemy_container = get_tree().get_root().get_node("Game").get_node("EnemyContainer")
var projectile = preload("res://Weapons/Projectile.tscn")
var random = RandomNumberGenerator.new()
@onready var player = get_tree().get_root().get_node("Game").get_node("Player")
@onready var unload = $Unload
@onready var reload = $Reload
var level : int = 0

func start():
	reload.wait_time = max(profile.reload_time.x,0.01)
	unload.wait_time = max(profile.unload_time.x,0.01)
	unload.start()

func _ready() -> void:
	reload.wait_time = max(profile.reload_time.x,0.01)
	unload.wait_time = max(profile.unload_time.x,0.01)
	unload.start()

#need to add collision layers
func shoot():
	if profile.sound:
		play_sound(profile.sound,AudioServer.get_bus_name(2))
	var spread = deg_to_rad(profile.spread.x)/round(min(profile.multishot.x,(profile.spread.x/20)+1))
	var spread_offset = deg_to_rad(profile.spread.x/2)
	for i in round(min(profile.multishot.x,(profile.spread.x/20)+1)):
		var instance = projectile.instantiate()
		instance.global_position = global_position
		if profile.hit_sound:
			instance.hit_sound = profile.hit_sound
		#instance.collision_layer = 4
		instance.scale.x = profile.scale.x
		instance.scale.y = profile.scale.x
		instance.frames = profile.frames
		instance.speed = profile.speed.x
		instance.pierce = profile.pierce.x
		instance.damage = profile.damage.x + max(0,(profile.multishot.x-(profile.spread.x/20)+1)*profile.damage.x/profile.multishot.x)

		instance.collision_shape = profile.collision_shape
		instance.lifetime_override = profile.lifetime_override
		
		instance.circling_radius = profile.circling_radius.x
		
		if profile.aim_type == 0:
			instance.direction = Vector2(0,1).rotated(spread*(i-1))
		if profile.aim_type == 1:
			var dir = player.input.normalized()
			if dir == Vector2.ZERO:
				dir = Vector2(0,1)
			instance.direction = dir.rotated(spread*i-spread_offset)
		if profile.aim_type == 2:
			var dir = global_position.direction_to(find_closest(global_position, enemy_container.get_children())-player.velocity/5)
			instance.direction = dir.rotated(spread*i-spread_offset)
		if profile.aim_type == 3:
			instance.initial_velocity = Vector2.ZERO
			if player.velocity != Vector2.ZERO:
				projectile_container.add_child.call_deferred(instance)

		else:
			if profile.follow_player:
				instance.position = Vector2.ZERO
				player.add_child.call_deferred(instance)
			else:
				instance.initial_velocity = player.velocity
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
	if not profile.unload_time.x >= 0.01:
		profile.damage.x += 1
		profile.unload_time.x = 0.01
	#reload_time
	profile.reload_time.x += profile.reload_time.y
	if not profile.reload_time.x >= 0.01:
		profile.damage.x += 2
		profile.reload_time.x = 0.01
	#pierce
	profile.pierce.x += profile.pierce.y
	#speed
	profile.speed.x += profile.speed.y
	#scale
	profile.scale.x += profile.scale.y
	#circling radius
	profile.circling_radius.x += profile.circling_radius.y
	#timers
	reload.wait_time = profile.reload_time.x
	unload.wait_time = profile.unload_time.x
	ammo = round(profile.ammo.x)
	unload.start()
	level += 1

func play_sound(sound : AudioStream, bus : String):
	var stream_player = AudioStreamPlayer.new()
	stream_player.stream = sound
	stream_player.bus = bus
	player.add_child(stream_player)
	stream_player.play()
	stream_player.connect("finished", audio_finished.bind(stream_player))

func audio_finished(stream_player):
	stream_player.queue_free()

func find_closest(from : Vector2, selection : Array):
	if selection.size() > 0:
		var closest : Vector2 = selection[0].global_position
		for pos in selection:
			if from.distance_to(closest) > from.distance_to(pos.global_position):
				closest = pos.global_position
		return closest
	else:
		return Vector2.ZERO

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
