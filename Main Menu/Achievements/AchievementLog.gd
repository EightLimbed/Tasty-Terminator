extends Resource

class_name AchievmentsLog

@export var achievements : Dictionary

func verify_save():
	DirAccess.make_dir_absolute("user://save")
