extends Node2D

var noise = FastNoiseLite.new()
var roads_done : Array = []

var random = RandomNumberGenerator.new()
@onready var roads = $Roads

func _ready():
	noise.noise_type = FastNoiseLite.TYPE_VALUE
	noise.frequency = 0.2
	noise.fractal_type = FastNoiseLite.FRACTAL_RIDGED
	noise.fractal_gain = 0.01
	noise.seed = random.randi()

#roads
func generate_roads(pos : Vector2i, size : Vector2i):
	for x in size.x:
		for y in size.y:
			var updated_pos = roads.local_to_map(pos)-size/2+Vector2i(x,y)
			var alt : int = round_noise(updated_pos)
			var surrounding = [round_noise(updated_pos+Vector2i(1,1)), round_noise(updated_pos+Vector2i(-1,1)), round_noise(updated_pos+Vector2i(-1,-1)), round_noise(updated_pos+Vector2i(1,-1))]

			if alt == 1 and surrounding.has(0):
				var atlas = Vector2i(1,1)
				if not roads_done.has(updated_pos+Vector2i(1,0)):
					atlas.x += 2
				if not roads_done.has(updated_pos+Vector2i(0,1)):
					atlas.y += 2
				if not roads_done.has(updated_pos+Vector2i(-1,0)):
					atlas.x -= 1
				if not roads_done.has(updated_pos+Vector2i(0,-1)):
					atlas.y -= 1
				roads.set_cell(updated_pos, 0, atlas)
				if not roads_done.has(updated_pos):
					roads_done.append(updated_pos)

func round_noise(pos : Vector2i):
	var alt : int = round(noise.get_noise_2d(pos.x, pos.y))
	return alt
