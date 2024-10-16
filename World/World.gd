extends Node2D

var profile : World

var roads_cache : Array = []
var building_cache : Array = []

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
	var cache_size = size.x*size.y*1.1
	buildings.clear()
	for x in size.x:
		for y in size.y:
			var updated_pos = buildings.local_to_map(pos)-size/2+Vector2i(x,y)
			var directions : Array[Vector2i] = [Vector2i(1,0), 
											Vector2i(-1,0), 
											Vector2i(0,1), 
											Vector2i(0,-1)]
			
			random.seed = hash(updated_pos)
			if not updated_pos.x % 5 ==0 and not updated_pos.y % 5 ==0:
				#if random.randi_range(0,5)>=1:
					if not roads_cache.has(updated_pos):
						
						if not building_cache.has(updated_pos):
							building_cache.append(updated_pos)
							if building_cache.size() > cache_size:
								building_cache.remove_at(0)
						var atlas = Vector2i(1,1)
						if not building_cache.has(updated_pos+directions[0]):
							atlas.x +=1
						if not building_cache.has(updated_pos+directions[2]):
							atlas.y +=1
						if not building_cache.has(updated_pos+directions[1]):
							atlas.x -=1
						if not building_cache.has(updated_pos+directions[3]):
							atlas.y -=1 
						
						buildings.set_cell(updated_pos, 0, atlas)
						if atlas.y == 1:
							if roads_cache.has(updated_pos + directions[0]) or roads_cache.has(updated_pos + directions[1]):
								#buildings.set_cell(updated_pos, -1, atlas)
								pass
						if atlas.x ==1:
							if roads_cache.has(updated_pos + directions[2]) or roads_cache.has(updated_pos + directions[3]):
								#buildings.set_cell(updated_pos, -1, atlas)
								pass
