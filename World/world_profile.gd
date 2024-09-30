extends Resource

class_name World

#tiles to choose from for background
@export var main_tiles : TileSet

#tiles to choose from for roads
@export var road_tiles : TileSet
@export var road_frequency : float = 0.006

#tiles to choose from for building, y is roof, middle, bottom, x is kinds of things for each (do 3)
@export var building_tiles : TileSet
@export var building_height : int
#specifies whether building parts can mix
@export var shuffle_top : bool
@export var shuffle_middle : bool
@export var shuffle_bottom : bool

#powerup textures
@export var crate_textures : SpriteFrames
