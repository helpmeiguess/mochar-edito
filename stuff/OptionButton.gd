extends OptionButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_item('Sine', 1)
	add_item('Linear', 0)
	add_item('Bounce', 9)
	add_item('Back', 10)
	add_item('Circ', 8)
	add_item('Cube', 7)
	add_item('Quint', 6)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
