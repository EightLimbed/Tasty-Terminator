extends TextureButton

var upgrade_texture = preload("res://HUD/Art/UpgradeWeapon.png")
var new_texture = preload("res://HUD/Art/NewWeapon.png")

func update_texture(id):
	if id is int:
		texture_normal = upgrade_texture
	else:
		texture_normal = new_texture
