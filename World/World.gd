extends Node2D

var profile : World

var roads_cache : Array = []

var generated : Array = []
var built : Array = []

var random = RandomNumberGenerator.new()
var noise = FastNoiseLite.new()
@onready var roads = $Roads
@onready var buildings = $Buildings

func _ready():
	profile = load("res://World/Resources/NewYork.tres")

	roads.tile_set = profile.tileset
	noise.frequency = profile.road_frequency

	noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	noise.cellular_jitter = 0
	noise.cellular_return_type = FastNoiseLite.RETURN_CELL_VALUE
	noise.seed = random.randi()

#roads
func generate_roads(pos : Vector2i, size : Vector2i):
	var cache_size = size.x*size.y*1.1
	roads.clear()

	for x in size.x:
		for y in size.y:
			var updated_pos = roads.local_to_map(pos)-size/2+Vector2i(x,y)
			var alt : int = round(noise.get_noise_2dv(updated_pos)*10)
			var surrounding : Array[int] = [round(noise.get_noise_2dv(updated_pos+Vector2i(1,1))*10), 
											round(noise.get_noise_2dv(updated_pos+Vector2i(-1,1))*10), 
											round(noise.get_noise_2dv(updated_pos+Vector2i(1,-1))*10), 
											round(noise.get_noise_2dv(updated_pos+Vector2i(-1,-1))*10)]
			#autotile
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
#buildings
func generate_buildings(pos : Vector2i, size : Vector2i):
	
	buildings.clear()
	for x in size.x:
		for y in size.y:
			var updated_pos = buildings.local_to_map(pos)-size/2+Vector2i(x,y)
			var surrounding : Array[Vector2i] = [updated_pos+Vector2i(1,0), 
											updated_pos+Vector2i(-1,0), 
											updated_pos+Vector2i(0,-1), 
											updated_pos+Vector2i(0,1)]
			if  updated_pos not in generated:
				if not roads_cache.has(updated_pos):
					if roads_cache.has(surrounding[0]) or roads_cache.has(surrounding [1]) or roads_cache.has(surrounding [2]) or roads_cache.has(surrounding [3]):
						generated.append(updated_pos)
						if random.randi_range(0,10) ==9:
							buildings.set_cell(updated_pos, 0, Vector2i(0,0))
							built.append(updated_pos)
			if updated_pos in built:
				buildings.set_cell(updated_pos, 0, Vector2i(0,0))
