extends TextureButton

var upgrade_texture = preload("res://HUD/Art/UpgradeWeapon.png")
var new_texture = preload("res://HUD/Art/NewWeapon.png")
@onready var weapon_container = get_tree().get_root().get_node("Game").get_node("Player").get_node("WeaponContainer")
@onready var item_display = $TextureRect
@onready var item_name = $Label

func update_texture(id):
	if id is int:
		texture_normal = upgrade_texture
		var child = weapon_container.get_child(id)
		item_display.texture = child.profile.display
		item_name.text = child.profile.name
	else:
		texture_normal = new_texture
		item_display.texture = id.display
		item_name.text = id.name
