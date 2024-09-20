extends Node2D

var visited_roads : Array = []
@onready var roads = $Roads

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_roads(pos : Vector2i, size : Vector2i):
	for x in size.x:
		for y in size.y:
			var updated_pos = pos-(size/2)+Vector2i(x,y)
			if not visited_roads.has(updated_pos):
				pass
				#set cell using autotiling
