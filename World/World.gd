extends Node2D

var roads_cache : Array = []

var random = RandomNumberGenerator.new()
var noise = FastNoiseLite.new()
@onready var roads = $Roads
@onready var visual_noise = $Noise

func _ready():
	noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	noise.cellular_jitter = 0
	#noise.cellular_distance_function = FastNoiseLite.DISTANCE_MANHATTAN
	noise.frequency = 0.007
	noise.cellular_return_type = FastNoiseLite.RETURN_CELL_VALUE
	noise.seed = random.randi()

#roads
func generate_roads(pos : Vector2i, size : Vector2i):
	var cache_size = size.x*size.y
	#noise.position = pos
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
					if roads_cache.size() > cache_size:
						roads_cache.remove_at(0)
					roads_cache.append(updated_pos)
