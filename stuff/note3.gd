extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var j = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_note3_button_down():
	for i in $'/root/Node2D'.selected:
		if $'/root/Node2D'.keyframes[i-1][1] == 3:
			if !$'/root/Node2D'.playing:
				j = true
			else:
				j = false #useless but i dont care
func _process(delta):
	set_rotation_degrees(get_node("notedir").global_rotation_degrees)
	if !$'/root/Node2D'.playing and j == true:
		rect_position = get_global_mouse_position() - (rect_size / 2)				

func _on_note3_button_up():
	for i in $'/root/Node2D'.selected:
				$'/root/Node2D'.keyframes[i-1][3] = (rect_position.x - $'/root/Node2D'.ogposx[ 3-1]) / 0.35
				$'/root/Node2D'.keyframes[i-1][4] = (rect_position.y - $'/root/Node2D'.ogposy[ 3-1]) / 0.35

				var keyframes = $'/root/Node2D'.keyframes
				initx(keyframes[i-1][3])
				inity(keyframes[i-1][4])
				initangle(keyframes[i-1][5])
				initalpha(keyframes[i-1][7])
				initdir(keyframes[i-1][6])

	j = false
func initx(a):
	$'/root/Node2D'.initx(a)
func inity(a):
	$'/root/Node2D'.inity(a)
func initangle(a):
	$'/root/Node2D'.initangle(a)
func initalpha(a):
	$'/root/Node2D'.initalpha(a)
func initdir(a):
	$'/root/Node2D'.initdir(a)
