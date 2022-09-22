extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var j = false

func _on_Button_button_down():
	j = true
	#Node2d.get_node('ScrollContainer/MarginContainer')._on_keyframe_down(get_node('../').id, 'ScrollContainer/MarginContainer/' + str(get_node('../').id))


func _on_Button_button_up():
	j = false
	release_focus()
	#for i in Node2d.get_node('ScrollContainer/MarginContainer').selected:
		#Node2d.get_node('ScrollContainer/MarginContainer')._on_keyframe_up(get_node('../').id)
