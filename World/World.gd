extends Node2D

var profile = preload("res://World/NewYork.tres")
var noise = FastNoiseLite.new()
var roads_done : Array = []
var intersections : Array = []

var move = 1
var tiles_left = 128*128
var center = 0
var updated_pos = Vector2i(0,0)

var random = RandomNumberGenerator.new()
@onready var roads = $Roads

func _ready():
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	generate_roads(Vector2i(0,0), Vector2i(16,16))
	#roads.tile_set = profile.road_tiles
	pass

func generate_roads(pos : Vector2i, size : Vector2i):
	for x in size.x:
		for y in size.y:
			var updated_pos = pos-size/2+Vector2i(x,y)
			var alt = round(noise.get_noise_2d(updated_pos.x, updated_pos.y)+0.5)
			print(alt)
			

func _process(delta):
	pass
