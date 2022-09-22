extends HScrollBar


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
# every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta):
	rect_rotation = -get_node('../').rect_rotation

func _on_HScrollBar_value_changed(value):
	get_node('../').self_modulate.a = value / 100
	for i in get_node('/root/Node2D').selected:
		get_node('/root/Node2D').keyframes[i-1][7] = value / 100
		get_node('/root/Node2D').initalpha(value / 100)
