extends Node2D

var profile : World

var roads_cache : Array = []

var random = RandomNumberGenerator.new()
var noise = FastNoiseLite.new()
@onready var roads = $Roads
@onready var buildings = $Buildings

var state = random.state
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
			var directions : Array[Vector2i] = [Vector2i(1,0), 
											Vector2i(-1,0), 
											Vector2i(0,1), 
											Vector2i(0,-1)]
			
			random.seed = hash(updated_pos)
			var sx = random.randi_range(3,4)
			var sy = random.randi_range(3,4)
			var build_size = Vector2i(sx,sy)
			if not roads_cache.has(updated_pos):
				
					if roads_cache.has(updated_pos +directions[0]*2) or roads_cache.has(updated_pos +directions[1]*2) or roads_cache.has(updated_pos +directions[2]*2)or roads_cache.has(updated_pos +directions[3]*2):
						if random.randi_range(0,10) ==0:
							
							for i in build_size.x:
								for j in build_size.y:
									var cx = i
									var cy = j
									if cy> build_size.y/2:
										cy -= build_size.y/2
										cy*= -1
									if cx> build_size.x/2:
										cx -= build_size.x/2
										cx*= -1
									'''for d in directions.size():
										if roads_cache.has(updated_pos +directions[d]):
											if d <= 1:
												cx = i * -directions[d].x
											if d >=2:
												cy = j* -directions[d].y '''
									if not roads_cache.has(updated_pos + Vector2i(cx , cy)):
										buildings.set_cell(updated_pos + (Vector2i(cx,cy)), 0, Vector2i(1,0))
							buildings.set_cell(updated_pos, 0, Vector2i(0,0))
