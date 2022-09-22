extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
var j = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_rotate_button_down():
	
	j = true

func _process(delta):
	if j:
		get_node('../notedir').look_at(get_global_mouse_position())
func _on_rotate_button_up():
	j = false
	for i in $'/root/Node2D'.selected:
		$'/root/Node2D'.keyframes[i-1][5] = get_node('../').rect_rotation
