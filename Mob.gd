extends RigidBody2D

export var min_speed = 150 # Vitesse minimale
export var max_speed = 250 # Vitesse maximale

func _ready():
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func get_min_speed():
	return min_speed

func get_max_speed():
	return max_speed

func set_min_speed(value):
	min_speed = value

func set_max_speed(value):
	max_speed = value
