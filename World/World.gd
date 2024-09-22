extends Node2D

var profile = preload("res://World/NewYork.tres")

var roads_done : Array = []
var intersections : Array = []

var random = RandomNumberGenerator.new()
@onready var roads = $Roads

func _ready():
	generate_roads(Vector2i(0,0), Vector2i(64, 64))
	#make_line(Vector2i(0,0), Vector2(12,10))
	#roads.tile_set = profile.road_tiles
	pass

func _process(delta):
	#generate_roads(Vector2i(0,0), Vector2i(512, 256))
	pass

#remember to use local_to_map for position
func generate_roads(pos : Vector2i, size : Vector2i):
	#just make grid, but warp it, and connect points for roads
	pass
