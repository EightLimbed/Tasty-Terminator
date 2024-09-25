extends Node2D

var roads_cache : Array = []

var random = RandomNumberGenerator.new()
@onready var roads = $Roads
@onready var noise = $Noise

func _ready():
	pass

#roads
func generate_roads(pos : Vector2i, size : Vector2i, cache_size : int):
	#noise.position = pos
	roads.clear()
	noise.texture.noise.offset = Vector3i(roads.local_to_map(pos).x, roads.local_to_map(pos).y, 0)
	var image = noise.texture.get_image()
	for x in size.x:
		for y in size.y:
			var updated_pos = roads.local_to_map(pos)-size/2+Vector2i(x,y)
			var alt : Color = image.get_pixel(x,y)
			#autotile
			if alt != Color("7f7fff"):
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
					#if roads_cache.size() > cache_size:
						#roads_cache.remove_at(0)
					roads_cache.append(updated_pos)
