extends ScrollContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_h_scrollbar().allow_greater = true
func _process(delta):
	if get_h_scrollbar().value > get_node('/root/Node2D').cool:
		get_h_scrollbar().value = get_node('/root/Node2D').cool
# Called every frame. 'delta' is the elapsed time since the previous frame.

