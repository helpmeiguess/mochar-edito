extends Line2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rotat_e = 0.0

# Called when the node enters the scene tree for the first time.
func _process(delta):
	rotat_e = (get_node('../direction').rotation_degrees)
	global_rotation_degrees = rotat_e #bananase               ro   tat    e


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
