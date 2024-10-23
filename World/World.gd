extends Node2D

var roads_cache : Array = []

var random = RandomNumberGenerator.new()
var noise = FastNoiseLite.new()
@onready var ground = $Ground
@onready var roads = $Roads
@onready var obstacles = $Obstacles
var obstacle_chance_big : int
var obstacle_chance_small : int

func update_profile(profile : World):
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
