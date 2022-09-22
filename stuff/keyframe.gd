
extends Polygon2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var id = -1
var ogposx = []
var ogposy = []
var chrochet = 0.0
var j = false
var selected = []
# Called when the node enters the scene tree for the first time.
func _ready():
	self.show_on_top = true

	
# warning-ignore:unused_argument
func _process(delta):
	chrochet = $'/root/Node2D'.chrochet
	if j == true:
		if get_global_mouse_position().x > 150:
			if !Input.is_action_pressed("shift"):
				position.x = ((floor((((get_global_mouse_position().x + ((get_node('/root/Node2D/ScrollContainer').scroll_horizontal) - chrochet / 4))) - 150) / (chrochet / 2)) + 1) * (chrochet / 2))
				$"/root/Node2D".keyframes[id-1][0] = position.x * 8
				if (floor(((get_global_mouse_position().y - get_node('/root/Node2D/ScrollContainer').rect_position.y) / 23.8) + 1) * 23.8) > 0 and (floor(((get_global_mouse_position().y - get_node('/root/Node2D/ScrollContainer').rect_position.y) / 23.8) + 1) * 23.8) < 192:
					position.y = floor((get_global_mouse_position().y - get_node('/root/Node2D/ScrollContainer').rect_position.y) / 23.8) * 23.8
				$"/root/Node2D".keyframes[id-1][1] = floor((get_global_mouse_position().y - get_node('/root/Node2D/ScrollContainer').rect_position.y) / 23.8) + 1
				for i in get_node('/root/Node2D').selected:
						if i != id:
							if ogposx[i-1] != null:
								if get_global_mouse_position().x - (ogposx[id-1] - ogposx[i-1]) > 150:
									get_node('/root/Node2D/ScrollContainer/MarginContainer/' + str(i)).position.x = position.x - ((ogposx[id-1] - ogposx[i-1]))
									if position.y - ((ogposy[id-1] - ogposy[i-1]) - 23.8) < 192 and position.y - ((ogposy[id-1] - ogposy[i-1]) - 23.8) > 0:
										get_node('/root/Node2D/ScrollContainer/MarginContainer/' + str(i)).position.y = position.y - ((ogposy[id-1] - ogposy[i-1]))
			else:
				position.x = (get_global_mouse_position().x + get_node('/root/Node2D/ScrollContainer').scroll_horizontal) - 150
				$"/root/Node2D".keyframes[id-1][0] = position.x * 8
				if (floor(((get_global_mouse_position().y - get_node('/root/Node2D/ScrollContainer').rect_position.y) / 23.8) + 1) * 23.8) > 0 and (floor(((get_global_mouse_position().y - get_node('/root/Node2D/ScrollContainer').rect_position.y) / 23.8) + 1) * 23.8) < 192:
					position.y = floor((get_global_mouse_position().y - get_node('/root/Node2D/ScrollContainer').rect_position.y) / 23.8) * 23.8
				$"/root/Node2D".keyframes[id-1][1] = floor((get_global_mouse_position().y - get_node('/root/Node2D/ScrollContainer').rect_position.y) / 23.8) + 1
				for i in get_node('/root/Node2D').selected:
						if i != id:
							if ogposx[i-1] != null:
								if get_global_mouse_position().x - (ogposx[id-1] - ogposx[i-1]) > 150:
									get_node('/root/Node2D/ScrollContainer/MarginContainer/' + str(i)).position.x = position.x - ((ogposx[id-1] - ogposx[i-1]))
									if position.y - ((ogposy[id-1] - ogposy[i-1]) - 23.8) < 192 and position.y - ((ogposy[id-1] - ogposy[i-1]) - 23.8) > 0:
										get_node('/root/Node2D/ScrollContainer/MarginContainer/' + str(i)).position.y = position.y - ((ogposy[id-1] - ogposy[i-1]))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_down():
	
	if Input.is_action_pressed("shift"):
		get_node('/root/Node2D').selected = get_node('/root/Node2D').selected + [id]
		get_node('/root/Node2D').the = true
		$'/root/Node2D'.refresh()
#		selpath = selpath + [path]
	elif Input.is_action_pressed("ctrl"):
		get_node('/root/Node2D').selected = [id]
		get_node('/root/Node2D').the = true
		$'/root/Node2D'.refresh()
	else:
		ogposx = []
		for i in get_node('/root/Node2D').keyframes:
			if i != [null]:
				ogposx = ogposx + [get_node('/root/Node2D/ScrollContainer/MarginContainer/' + str(i[-1])).global_position.x]
			else:
				ogposx = ogposx + [null]
		ogposy = []
		for i in get_node('/root/Node2D').keyframes:
			if i != [null]:
				ogposy = ogposy + [get_node('/root/Node2D/ScrollContainer/MarginContainer/' + str(i[-1])).global_position.y]
				
			else:
				ogposy = ogposy + [null]
		j = true
		get_node('/root/Node2D').the = true


func _on_Button_button_up():
	j = false
	for i in get_node('/root/Node2D').selected:
		get_node('/root/Node2D').keyframes[i-1][0] = ((get_node('/root/Node2D/ScrollContainer/MarginContainer/' + str(i)).global_position.x - 150) + get_node('/root/Node2D/ScrollContainer').scroll_horizontal) * 8
		get_node('/root/Node2D').keyframes[i-1][1] = (floor((get_node('/root/Node2D/ScrollContainer/MarginContainer/' + str(i)).global_position.y - 192) / 23.8) - 8)
		print(get_node('/root/Node2D').keyframes[i-1][1])
	get_node('/root/Node2D').the = false
	$'/root/Node2D'.refresh()
	
