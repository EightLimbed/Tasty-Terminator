extends CanvasLayer

@onready var health_bar = $Healthbar
@onready var experience_bar = $Experiencebar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_health(min,val,max):
	health_bar.min_value = min
	health_bar.max_value = max
	health_bar.value = val

func update_experience(min,val,max):
	experience_bar.min_value = min
	experience_bar.max_value = max
	experience_bar.value = val
	
