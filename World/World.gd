extends Node2D

var profile = preload("res://World/NewYork.tres")

var visited_roads : Array = []
@onready var roads = $Roads

func _ready():
	#roads.tile_set = profile.road_tiles
	generate_roads(Vector2i(0,0), Vector2i(64, 64))

func _process(delta):
	pass

#remember to use local_to_map for position
func generate_roads(pos : Vector2i, size : Vector2i):
	for x in size.x:
		for y in size.y:
			var updated_pos = pos-(size/2)+Vector2i(x,y)
			if not visited_roads.has(updated_pos):
				#use get_surounding_cells() or get_neighbor_cell() for rules

				pass
