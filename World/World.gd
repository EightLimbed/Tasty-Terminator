extends Node2D

var roads_cache : Array = []
var pickups_cache : Array = []

var random = RandomNumberGenerator.new()
var noise = FastNoiseLite.new()
@onready var ground = $Ground
@onready var roads = $Roads
@onready var obstacles = $Obstacles
@onready var pickup_container = $PickupContainer
var pickup = preload("res://Weapons/Pickup.tscn")
var pickup_selection : Array[Weapon] = [preload("res://Weapons/Resources/Magnet.tres"),preload("res://Weapons/Resources/Magnet.tres"),preload("res://Weapons/Resources/Magnet.tres"),preload("res://Weapons/Resources/Revival.tres")]
var obstacle_chance_big : int
var obstacle_chance_small : int
var pickup_chance : int

func update_profile(profile : World):
	pickups_cache.clear()
	for child in pickup_container.get_children():
		child.queue_free()
	ground.tile_set = profile.tileset
	roads.tile_set = profile.tileset
	obstacles.tile_set = profile.tileset
	noise.frequency = profile.road_frequency
	noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	noise.cellular_jitter = 0
	noise.cellular_return_type = FastNoiseLite.RETURN_CELL_VALUE
	noise.seed = profile.seeded
	obstacle_chance_big = profile.obstacle_chance_big
	obstacle_chance_small = profile.obstacle_chance_small
	pickup_chance = profile.pickup_chance
	if profile.name == "Desert":
		create_pickup(pickup_selection[3], Vector2(0,-4096))
		create_pickup(load("res://Weapons/Resources/Gun.tres"), Vector2(4096,-4096))

#roads
func generate_roads(pos : Vector2i, size : Vector2i):
	var cache_size = size.x*size.y*1.1
	roads.clear()
	obstacles.clear()
	ground.clear()

	for x in size.x:
		for y in size.y:
			var updated_pos = roads.local_to_map(pos)-size/2+Vector2i(x,y)
			var alt : int = round(noise.get_noise_2dv(updated_pos)*10)
			random.seed = hash(updated_pos*noise.seed)
			if random.randi_range(0,pickup_chance) == 0 and pickup_chance > 0 and not updated_pos.x % 2:
				if not pickups_cache.has(updated_pos):
					create_pickup(pickup_selection[random.randi_range(0,pickup_selection.size()-1)], roads.map_to_local(updated_pos))
					pickups_cache.append(updated_pos)
			ground.set_cell(updated_pos, 1, Vector2i(random.randi_range(0,2), random.randi_range(0,2)))
			var surrounding : Array[int] = [round(noise.get_noise_2dv(updated_pos+Vector2i(1,1))*10), 
											round(noise.get_noise_2dv(updated_pos+Vector2i(-1,1))*10), 
											round(noise.get_noise_2dv(updated_pos+Vector2i(1,-1))*10), 
											round(noise.get_noise_2dv(updated_pos+Vector2i(-1,-1))*10)]
			if surrounding[0] != alt or surrounding[1] != alt or surrounding[2] != alt or surrounding[3] != alt:
				var atlas = Vector2i(1,1)
				if not roads_cache.has(updated_pos+Vector2i(1,0)):
					atlas.x += 1
				if not roads_cache.has(updated_pos+Vector2i(0,1)):
					atlas.y += 1
				if not roads_cache.has(updated_pos+Vector2i(-1,0)):
					atlas.x -= 1
				if not roads_cache.has(updated_pos+Vector2i(0,-1)):
					atlas.y -= 1
				roads.set_cell(updated_pos, 0, atlas)
				if not roads_cache.has(updated_pos):
					roads_cache.append(updated_pos)
					if roads_cache.size() > cache_size:
						roads_cache.remove_at(0)
			else:
				if obstacle_chance_big+obstacle_chance_small > 0:
					var structure = random.randi_range(0,100)
					if structure<obstacle_chance_big and updated_pos.x % 2:
						obstacles.set_cell(updated_pos, 2, Vector2i(0,0))
					elif structure>obstacle_chance_big and structure<obstacle_chance_big+obstacle_chance_small and updated_pos.x % 2:
						obstacles.set_cell(updated_pos, 2, Vector2i(0,2))

func create_pickup(profile, pos):
	var instance = pickup.instantiate()
	instance.profile = profile
	instance.position = pos
	pickup_container.add_child.call_deferred(instance)
