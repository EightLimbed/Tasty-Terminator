extends Resource

class_name AchievmentsLog

@export var achievments : Dictionary

func verify_save():
	DirAccess.make_dir_absolute("user://save")
