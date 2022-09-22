extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var j = false

# Called when the node enters the scene tree for the first time.
func _process(delta):
	rect_position.x = (get_node('../hold').scale.x * 2) - 20
	if j:
		for i in get_node('/root/Node2D').selected:
			if i != get_node('../').id:
				get_node('/root/Node2D/ScrollContainer/MarginContainer/' + str(i) + '/hold').scale.x = get_node('../').get_local_mouse_position().x / 2
			else:
				get_node('../hold').scale.x = get_node('../').get_local_mouse_position().x / 2
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_holdbutton_button_down():
	j = true
	get_node('/root/Node2D').the = true


func _on_holdbutton_button_up():
	get_node('/root/Node2D').the = false
	j = false
	for i in get_node('/root/Node2D').selected:
		
		get_node('/root/Node2D').keyframes[i-1][2] = (get_node('../').get_local_mouse_position().x / 2) / 200
		print(get_node('/root/Node2D').keyframes[i-1])
