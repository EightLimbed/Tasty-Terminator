extends Node2D

var noise = FastNoiseLite.new()
var roads_cache : Array = []

var random = RandomNumberGenerator.new()
@onready var roads = $Roads

func _ready():
	noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	noise.frequency = 0.05
	noise.fractal_type = FastNoiseLite.FRACTAL_RIDGED
	noise.cellular_distance_function = FastNoiseLite.DISTANCE_MANHATTAN
	noise.cellular_return_type = FastNoiseLite.RETURN_CELL_VALUE
	noise.cellular_jitter = 0.5
	noise.seed = random.randi()

#roads
func generate_roads(pos : Vector2i, size : Vector2i, cache_size : int):
	if roads_cache.size() > cache_size:
		roads_cache.slice(cache_size/2, cache_size)
	roads.clear()
	for x in size.x:
		for y in size.y:
			var updated_pos = roads.local_to_map(pos)-size/2+Vector2i(x,y)
			var alt : float = round_noise(updated_pos)*2
			var surrounding : Array = []
			#autotile
			if alt < -0.4:
				var atlas = Vector2i(1,1)
				if not roads_cache.has(updated_pos+Vector2i(1,0)):
					atlas.x += 2
				if not roads_cache.has(updated_pos+Vector2i(0,1)):
					atlas.y += 2
				if not roads_cache.has(updated_pos+Vector2i(-1,0)):
					atlas.x -= 1
				if not roads_cache.has(updated_pos+Vector2i(0,-1)):
					atlas.y -= 1
				roads.set_cell(updated_pos, 0, atlas)
				if not roads_cache.has(updated_pos):
					roads_cache.append(updated_pos)

func round_noise(pos : Vector2i):
	var alt : float = (noise.get_noise_2d(pos.x, pos.y))
	print(alt)
	return alt
