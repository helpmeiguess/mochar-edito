extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
var j = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(_delta):
	if j:
		get_node('../direction').look_at(get_global_mouse_position())
		get_node('../direction').global_rotation_degrees -= 90 - get_node('../').rect_rotation
func _on_dirrotate_button_down():
	j = true


func _on_dirrotate_button_up():
	j = false
	
	for i in $'/root/Node2D'.selected:
		$'/root/Node2D'.keyframes[i-1][6] = -get_node('../direction').rotation_degrees + 90
		print($'/root/Node2D'.keyframes)
