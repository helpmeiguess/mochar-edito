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
	add_item('Circ because someone begged for it', 8)
	add_item('Cube because someone begged for it', 7)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
