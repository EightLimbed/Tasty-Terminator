extends Resource

class_name World

@export var name : String
@export var description : String

#tiles to choose from (0 for roads, 1 for buildings)
@export var tileset : TileSet
@export var road_frequency : float = 0.006
@export var obstacle_chance : int

#possible enemies (does same algorithm for selection, so keep in mind order used
@export var possible_enemies : Array[Enemy]

#powerup textures
@export var crate_textures : SpriteFrames
