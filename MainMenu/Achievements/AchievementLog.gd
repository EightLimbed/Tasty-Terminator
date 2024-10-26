extends Resource

class_name AchievmentsLog

@export var achievements : Dictionary
@export var music_volume : int
@export var control_type : bool

func verify_save():
	DirAccess.make_dir_absolute("user://save")
