extends CanvasLayer

@onready var health_bar = $Healthbar
@onready var experience_bar = $Experiencebar
#add weapon children
@onready var weapon_scene = preload("res://Weapons/Weapon.tscn")
@onready var player = get_tree().get_root().get_node("Game").get_node("Player")
@onready var weapon_container = player.get_node("WeaponContainer")
@onready var level_up_window = $Levelup
var random = RandomNumberGenerator.new()
var possible_weapons : Array[Weapon] = [preload("res://Weapons/Resources/ChocolateChips.tres"), preload("res://Weapons/Resources/Shotgun.tres")]
var max_weapons : int = 2
var level_cache : int = 0
@onready var option1_button = $Levelup/NinePatchRect/Option1
@onready var option2_button = $Levelup/NinePatchRect/Option2
@onready var option3_button = $Levelup/NinePatchRect/Option3
var option1
var option2
var option3

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in weapon_container.get_children():
		possible_weapons.erase(child.profile)
	add_weapon(possible_weapons[0])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#say "new" above new weapon, have overlay on it, and give description when hovered. everything else will be "upgrade to [level] and show what stats are, and what increases when hovered." Both will have picture of weapon
func level_up():
	if level_up_window.visible:
		level_cache += 1
	else:
		for child in weapon_container.get_children():
			possible_weapons.erase(child.profile)
		level_up_window.visible = true
		if weapon_container.get_child_count() < 2:
			option1 = possible_weapons[random.randi_range(0,possible_weapons.size()-1)]
			option2 = possible_weapons[random.randi_range(0,possible_weapons.size()-1)]
			option3 = possible_weapons[random.randi_range(0,possible_weapons.size()-1)]
		else:
			if weapon_container.get_child_count() < max_weapons and random.randi_range(0,2) == 0:
				option1 = possible_weapons[random.randi_range(0,possible_weapons.size()-1)]
			else:
				option1 = random.randi_range(0, weapon_container.get_child_count()-1)
			option2 = random.randi_range(0, weapon_container.get_child_count()-1)
			option3 = random.randi_range(0, weapon_container.get_child_count()-1)
		option1_button.update_texture(option1)
		option2_button.update_texture(option2)
		option3_button.update_texture(option3)
		level_cache -= 1

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
	var child = weapon_container.get_child(index)
	child.upgrade()

func _on_option_1_pressed():
	if option1 is int:
		upgrade_weapon(option1)
	if option1 is Weapon:
		add_weapon(option1)
	level_up_window.visible = false
	if level_cache > 0:
		level_up()

func _on_option_2_pressed():
	if option2 is int:
		upgrade_weapon(option2)
	if option2 is Weapon:
		add_weapon(option2)
	level_up_window.visible = false
	if level_cache > 0:
		level_up()

func _on_option_3_pressed():
	if option3 is int:
		upgrade_weapon(option3)
	if option3 is Weapon:
		add_weapon(option3)
	level_up_window.visible = false
	if level_cache > 0:
		level_up()
