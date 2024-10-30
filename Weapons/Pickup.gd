extends Area2D

var profile : Weapon
@onready var sprite = $Sprite2D2

func _ready():
	sprite.texture = profile.display

func _on_body_entered(_body):
	var HUD = get_tree().get_root().get_node("Game").get_node("Player").get_node("HUD")
	HUD.level_up(profile)
	queue_free()
