extends Node2D

var dragging = false  # Are we currently dragging?
var selected = []  # Array of selected units.
var drag_start = Vector2.ZERO  # Location where drag began.
var select_rect = RectangleShape2D.new()  # Collision shape for drag box.
#func _ready():
	
func _input(event):
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.doubleclick == false and get_node('/root/Node2D').chrochet != 0:
		if event.pressed:
			print('eventj')
			if get_node('/root/Node2D').inside(event.global_position, get_node("/root/Node2D/ScrollContainer").rect_global_position, get_node("/root/Node2D/ScrollContainer").rect_size) and !get_node('/root/Node2D').the:
					dragging = true
					drag_start = event.position
			
		elif dragging:
			
			# Button released while dragging.
			dragging = false
			update()
			var drag_end = event.position
			select_rect.extents = (drag_end - drag_start) / 2
			var space = get_world_2d().direct_space_state
			var query = Physics2DShapeQueryParameters.new()
			query.set_shape(select_rect)
			query.transform = Transform2D(0, (drag_end + drag_start) / 2)
			selected = space.intersect_shape(query)
			for i in get_node('/root/Node2D').selected:
				if get_node('/root/Node2D').keyframes[i-1] != [null]:
					get_node('/root/Node2D/ScrollContainer/MarginContainer/' + str(i)).modulate = Color(1,1,1)
			get_node('/root/Node2D').selected = []

			get_node('/root/Node2D').update = true
			
			for item in selected:
				if get_node('/root/Node2D').keyframes[item.collider.get_parent().id-1] != [null]:
					get_node('/root/Node2D').selected = get_node('/root/Node2D').selected + [item.collider.get_parent().id]
					var keyframe = get_node('/root/Node2D').keyframes[item.collider.get_parent().id-1]
					get_node('/root/Node2D').initx(keyframe[3])
					get_node('/root/Node2D').inity(keyframe[4])
					get_node('/root/Node2D').initangle(keyframe[5])
					get_node('/root/Node2D').initdir(keyframe[6])
					get_node('/root/Node2D').initalpha(keyframe[7])
					get_node('/root/Node2D').inittype(keyframe[8])
					get_node('/root/Node2D').inittwn(keyframe[9])
			if selected == []:
				get_node('/root/Node2D').songposition = (get_global_mouse_position().x + (get_node('/root/Node2D/ScrollContainer').scroll_horizontal - 150))
				get_node("/root/Node2D/BG/BG2/timeline").rect_position.x = get_global_mouse_position().x + (get_node('/root/Node2D/ScrollContainer').scroll_horizontal + 150)
			$'/root/Node2D'.refresh()
	if event is InputEventMouseMotion and dragging and !get_node('/root/Node2D').the:
		
		update()
	elif get_node('/root/Node2D').the:
		dragging = false

func _draw():
	if dragging:
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start),
				Color(1, 1, 1), false)
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start),
			Color(.5, .5, .5, .5), true)
