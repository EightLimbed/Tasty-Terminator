extends Resource

class_name Character

#sprite frames, put stand at beginning, two walking in middle, and dead at end
@export var sprite_frames : SpriteFrames
#name and description
@export var name : String
@export var description : String
#starting weapon
@export var starting_weapon : Weapon
#amount of level ups you start with
@export var head_start : int
#(flat bonus) max_health.x is starting health, max_health.y is what it goes up by every level
@export var max_health : Vector2i
#(flat bonus) health_regen.x is starting value, health_regen.y is increase every level
@export var health_regen : Vector2
#(flat bonus) speed.x is starting speed, speed.y is increase every level
@export var speed : Vector2i
#(multiplier) hunger multiplies difficulty scaling, hunger.x is base value, hunger.y is increase every level
@export var hunger : Vector2
#(multiplier) flavor multiplies incoming experience, flavor.x is base value, hunger.y is increase every level
@export var flavor : Vector2
