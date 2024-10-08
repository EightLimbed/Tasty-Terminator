extends CanvasLayer

@onready var health_bar = $Healthbar
@onready var experience_bar = $Experiencebar
#add weapon children
@onready var weapon_scene = preload("res://Weapons/Weapon.tscn")
@onready var player = get_tree().get_root().get_node("Game").get_node("Player")
@onready var weapon_container = player.get_node("WeaponContainer")
var possible_weapons : Array[Weapon] = [preload("res://Weapons/Resources/ChocolateChips.tres")]

# Called when the node enters the scene tree for the first time.
func _ready():
	add_weapon(possible_weapons[0])
	upgrade_weapon(0)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_health(minim,value,maxim):
	health_bar.min_value = minim
	health_bar.max_value = maxim
	health_bar.value = value

func update_experience(minim,value,maxim):
	experience_bar.min_value = minim
	experience_bar.max_value = maxim
	experience_bar.value = value

func add_weapon(weapon : Weapon):
	var instance = weapon_scene.instantiate()
	instance.profile = weapon
	weapon_container.add_child.call_deferred(instance)

func upgrade_weapon(index : int):
	pass
	#print(weapon_container.get_children().size())
	#weapon_container.get_child(index).upgrade()
