extends Node2D


var filedata = []
var songpath = ''
var bpm = 100.0
var chrochet = 0.0
var playing = false
var keyframes = []
var kfobjs = []
onready var timer = get_node("Timer")
onready var ogposx = [get_node("note1").duplicate().rect_position.x,get_node("note2").duplicate().rect_position.x,get_node("note3").duplicate().rect_position.x,get_node("note4").duplicate().rect_position.x,get_node("note5").duplicate().rect_position.x,get_node("note6").duplicate().rect_position.x,get_node("note7").duplicate().rect_position.x,get_node("note8").duplicate().rect_position.x,]
onready var ogposy = [get_node("note1").duplicate().rect_position.y,get_node("note2").duplicate().rect_position.y,get_node("note3").duplicate().rect_position.y,get_node("note4").duplicate().rect_position.y,get_node("note5").duplicate().rect_position.y,get_node("note6").duplicate().rect_position.y,get_node("note7").duplicate().rect_position.y,get_node("note8").duplicate().rect_position.y,]
var held = -1
var noteheld = 0
var songposition = 0.0
var lastsongposition = 0.0
var songplayer = AudioStreamPlayer.new()
var selected = []
var selpath = []
var kfposx = []
var the = false #retorded
var clipboard = []
var update = false
var theballs = false
var ogpos:Vector2
var time = 0
var cool = 0.0
var transitions = [Tween.EASE_IN_OUT,Tween.EASE_IN,Tween.EASE_OUT,Tween.EASE_OUT_IN]
var types = [1,0,9,10,8,7,6]
var coolaudiostream = AudioStreamOGGVorbis.new()
func indexof(array, find):
	var i = array.find(find)
	return i
func get_str(i, twn):
	if i == 1:
		return "sine" + get_tween_str(twn)
	if i == 0:
		return "linear"
	if i == 9:
		return "bounce" + get_tween_str(twn)
	if i == 10:
		return "back" + get_tween_str(twn)
	if i == 8:
		return "circ" + get_tween_str(twn)
	if i == 7:
		return "cubic" + get_tween_str(twn)
	if i == 6:
		return "quint" + get_tween_str(twn)
func get_tween_str(i):
	if i == Tween.EASE_IN:
		return "In"
	if i == Tween.EASE_OUT:
		return "Out"
	if i == Tween.EASE_IN_OUT:
		return "InOut"
	if i == Tween.EASE_OUT_IN
		return "OutIn"
	
func get_tween(note):
	return get_node('tween' + str(note))
func _ready():
	get_node('killme').popup_centered()
	get_tree().connect("files_dropped", self, "_on_files_dropped")
func _on_files_dropped(files, screen):
	songpath = files[0]
	var dir = File.new()
	dir.open(songpath, File.READ)
	coolaudiostream.data = dir.get_buffer(dir.get_len())
	get_node("Popup").popup_centered()
	remove_child(get_node("killme"))
func _ready2(): 
	
	add_child(songplayer)
	
	songplayer.stream = coolaudiostream
	for i in keyframes:
		makeKeyframe(i[1], i[0], false, indexof(keyframes, i) + 1, i, 0.5)
	chrochet = (60 / bpm) * 250
	cool = coolaudiostream.get_length() * 250
	print(ceil(coolaudiostream.get_length()*1000 / chrochet))
	for i in range(0,ceil(coolaudiostream.get_length()*1000 / chrochet)):
		if i % 4 == 0:
			var line = get_node("BG/beatline").duplicate()
			line.position.y = 0
			line.position.x = (((i * chrochet) / 2))
			line.add_to_group('lines')
			get_node("ScrollContainer/MarginContainer").add_child(line)
		else:
			var line = get_node("BG/stepline").duplicate()
			line.position.y = 0
			line.position.x = (((i * chrochet) / 2))

			line.add_to_group('lines')
			get_node("ScrollContainer/MarginContainer").add_child(line)
	get_node("ScrollContainer/MarginContainer").rect_min_size.x = (((100 * chrochet) / 2))
	for i in range(0,9):
		var line = get_node("BG/separator").duplicate()
		line.rect_position.y = ((24 * i))
		line.rect_position.x = 0
		
		line.add_to_group('lines')
		get_node("BG").add_child(line)
		#print(((27.2 * i[1])))
	refresh()
#func jupdate():
#	get_node("note" + str(noteheld)).rect_rect_position = Vector2(get_rect_mouse_position().x - (get_node("note" + str(noteheld)).rect_size.x / 2), get_rect_mouse_position().y - (get_node("note" + str(noteheld)).rect_size.y / 2))
func _process(delta):
	if chrochet != 0:
		if update:
			for item in keyframes:
				if item != [null]:
					if get_node('/root/Node2D/ScrollContainer/MarginContainer/' + str(indexof(keyframes, item)+1)) != null:
						get_node('/root/Node2D/ScrollContainer/MarginContainer/' + str(indexof(keyframes, item)+1)).color = Color(1,1,1)
		time += delta * 4
		for i in selected:
			get_node('/root/Node2D/ScrollContainer/MarginContainer/' + str(i)).color = Color(0.75 + (sin(time) / 4),0.75 + (sin(time) / 4),0)
#		if selpath != []:
#			for i in selpath:
#	
#				get_node(i).set_color(Color(0.75 + (sin(time) / 4),0.75 + (sin(time) / 4),0))
#				get_node('note' + str(keyframes[get_node(i).id - 1][1])).modulate = (Color(0.5 + (sin(time) / 4),0.5 + (sin(time) / 4),0.5 + (sin(time) / 4)))
#		else:
#			for i in keyframes:
#				if i != null:
#					if get_node("BG/Layer/" + str(indexof(keyframes,i) + 1)) != null:
#						get_node("BG/Layer/" + str(indexof(keyframes,i) + 1)).set_color(Color(1,1,1))
		if Input.is_action_just_pressed('a'):
			for i in keyframes:
				if i != [null]:
					selected = selected + [indexof(keyframes,i)+1]
		if Input.is_action_just_pressed("space") == true:
	
			if playing == true:
				songplayer.stop()
				refresh()
			else:
				for i in keyframes:
					i[0] = ((get_node("ScrollContainer/MarginContainer/" + str(i[-1])).global_position.x - 150) + get_node('/root/Node2D/ScrollContainer').scroll_horizontal) * 8
				for j in range(1,9):
					get_node("note" + str(j)).self_modulate = Color(1,1,1)
				if Input.is_action_pressed("ctrl"):
					songposition = 0.0
				for j in range(1,9):
					get_node("note" + str(j)).rect_position = Vector2(ogposx[j-1],ogposy[j-1])
					get_node("note" + str(j)).rect_rotation = 0
					get_node("note" + str(j) + '/direction').global_rotation_degrees = 0
				songplayer.play(songposition / 250)
				for j in range(1,9):
					get_node("note" + str(j) + '/rotate').visible = false
					get_node("note" + str(j) + '/dirrotate').visible = false
					get_node("note" + str(j) + '/HScrollBar').visible = false
	
					
			playing = !playing
	#		for i in range(1, 9):
#			get_tween(i).stop_all()
		get_node("BG/BG2/timeline").rect_position.x = songposition - (get_node('ScrollContainer').scroll_horizontal - 150)
		if playing == true:
			
			songposition = songplayer.get_playback_position() * 250
			for i in keyframes:
				if i != [null]:
					if (i[0] / 8) <= (songposition) + 5:
						if (i[0] / 8) >= (lastsongposition):
							if i[1] > 8:
								i[1] = 8
							elif i[1] <= 0:
								i[1] = 1
							get_tween(i[1]).stop_all()
							get_tween(i[1]).remove_all()
							get_tween(i[1]).interpolate_property(get_node("note" + str(i[1])), "rect_position", Vector2(get_node("note" + str(i[1])).rect_position.x, get_node("note" + str(i[1])).rect_position.y), Vector2(ogposx[i[1]-1] + (i[3] * 0.35), ogposy[i[1]-1] + (i[4] * 0.35)), i[2], i[8], i[9])
							get_tween(i[1]).start()
							get_tween(i[1]).interpolate_property(get_node("note" + str(i[1])), "rect_rotation", get_node("note" + str(i[1])).rect_rotation, i[5], i[2], i[8], i[9])
							get_tween(i[1]).start()
							get_tween(i[1]).interpolate_property(get_node("note" + str(i[1]) + '/direction'), "global_rotation_degrees", get_node("note" + str(i[1]) + '/direction').global_rotation_degrees, (-i[6]+90) + i[5], i[2], i[8], i[9])
							get_tween(i[1]).start()
							get_tween(i[1]).interpolate_property(get_node("note" + str(i[1])), "self_modulate", get_node("note" + str(i[1])).self_modulate, Color(1,1,1,i[7]), i[2], i[8], i[9])
							get_tween(i[1]).start()
			lastsongposition = songposition
#
#	if noteheld != 0 and !get_tween(noteheld).is_active():
#		jupdate()
#	#print(ogposx[1])
func inside(pos1, pos2, s):
	var x2 = pos2.x + s.x
	var y2 = pos2.y + s.y
	if ((pos2.x < pos1.x) and (pos1.x < x2)) == true:
		if ((pos2.y < pos1.y) and (pos1.y < y2)) == true:
			return true
	return false
func makeKeyframe(column, t, start, i, array = [], length = 0.5):

	var keyframe = get_node("BG/keyframe").duplicate()
#	keyframe.rect_position.y = (90 + (27.2 * i[1]))
#	keyframe.rect_position.x = 200
#	keyframe.add_to_group('lines')
	keyframe.position.y = (24 * (column - 1))
	keyframe.position.x = t / 8
	keyframe.get_node('hold').scale.x = length * 250
	keyframe.get_node('holdbutton').rect_position.x = length * 500 - 10
	keyframe.set_name(str(i))
	get_node("ScrollContainer/MarginContainer").add_child(keyframe)
	keyframe.id = i
	if start == false:
		var data = []
		if array != []:
			data = array
		else:
			data = [t, column, length, 0, 0, 0, 90, 1.0, 1, 2,i]
		keyframes = keyframes + [data]
#
#
#
#
#
#
#func _on_note_button_down(note):
#	for i in selected:
#		if keyframes[i][1] == note:
#			noteheld = note
#			break
#func _on_note_button_up():
#	if noteheld != 0:
#		if selected != []:
#			var x = (get_node('note' + str(noteheld)).rect_position.x / 0.49) - (ogposx[noteheld-1] / 0.49)
#			var y = (get_node('note' + str(noteheld)).rect_position.y / 0.49) - (ogposy[noteheld-1] / 0.49)
#			for i in selected:
#				var kf=keyframes[i]
#				kf[3] = x
#				kf[4] = y
#				initx(kf[3])
#				inity(kf[4])
#				initangle(kf[5])
#	noteheld = 0
#	for j in range(1,9):
#		get_node("note" + str(j)).modulate = Color(1,1,1)
#
#
#func _ease_button_down(extra_arg_0):
#	pass # Replace with function body.
#
#
#func _type_button_down(extra_arg_0):
#	pass # Replace with function body.

#	(keyframes[id - 1])[0] = floor(((get_local_mouse_position().x + (chrochet / 4))) / (chrochet)) * chrochet
#	if len(selected) > 1:
#		for i in selected:
#			if keyframes[i] != null:
#				get_node('BG/Layer/' + str(i + 1)).rect_position.x = get_rect_mouse_position().x - (kfposx[id-1] - kfposx[i])
#func _on_keyframe_up(id):
#	theballs = false
#	(keyframes[id-1])[0] = (get_node('BG/Layer/' + str(id)).position.x - 1883) * 2
#	print((keyframes[id-1])[0])
#func _on_keyframe_down(id, path):
#	print(held)
#	theballs = true
#	kfposx = []
#	for i in keyframes:
#		if i != null:
#			kfposx = kfposx + [get_node('BG/Layer/' + str(indexof(keyframes, i) + 1)).rect_position.x]
#		selpath = [path]
#	initx(keyframes[id-1][3])
#	inity(keyframes[id-1][4])
#	initangle(keyframes[id-1][5])
#
#
#func _on_Button_button_up():
#	held = 0
func _input(event):
	if chrochet != null and chrochet != 0:
		if event.is_action_pressed("copy"):
			print('j')
			clipboard = []
			for i in selected:
				if keyframes[i-1] != [null]:
					clipboard = clipboard + [keyframes[i-1]]
	
	
		if event.is_action_pressed("paste"):
	
			selected = []
	
			for i in clipboard:
	
				var help = i.duplicate()
				help[-1] = len(keyframes) + 1
				makeKeyframe(i[1], i[0], false, len(keyframes) + 1, help, i[2])
				selected = selected + [len(keyframes)]
				refresh()
	#
		if event is InputEventMouseButton:
			if (get_global_mouse_position() > get_node('ScrollContainer').rect_position):
				if Input.is_action_pressed("shift") and event.pressed and event.button_index == 1:
					songposition = (get_global_mouse_position().x - (get_node('ScrollContainer').scroll_horizontal + 150))
					get_node("BG/BG2/timeline").rect_position.x = get_global_mouse_position().x - (get_node('ScrollContainer').scroll_horizontal)
			if !Input.is_action_pressed("ctrl") and !Input.is_action_pressed("shift"):
				if event.doubleclick and event.button_index == 1 and event.pressed:

					if (get_global_mouse_position() > get_node('ScrollContainer').rect_position):
						var thingy = false
						for i in range(1, len(keyframes) + 1):
							if keyframes[i-1] != [null]:
								if get_node("ScrollContainer/MarginContainer/" + str(i) + "/Button") != null:
									if inside(event.global_position, get_node("ScrollContainer/MarginContainer/" + str(i) + "/Button").rect_global_position, Vector2(20, 20)):
										thingy = true
						if thingy == false:
							var column = floor((get_global_mouse_position().y - get_node('ScrollContainer').rect_position.y) / 23.8)
							makeKeyframe(column + 1, ((floor((((get_local_mouse_position().x + ((get_node('ScrollContainer').scroll_horizontal) - chrochet / 4))) - 150) / (chrochet / 2)) + 1) * (chrochet * 4)), false, len(keyframes) + 1)
						
		#				for j in range(1,9):
		#					get_node("note" + str(j)).modulate = Color(1,1,1)
		#				var column = floor(get_local_mouse_position().y / 23.8)
							selected = [len(keyframes)]
							initx(0)
							inity(0)
							initangle(0)
							initdir(90)
							initalpha(1)
							inittwn(2)
							inittype(1)
							refresh()
		#				for i in selpath:
		#					get_node(i).set_color(Color(1,1,1))
		#				selpath = [makeKeyframe(column + 1, floor(((get_local_mouse_position().x + (chrochet / 4)) * 2) / (chrochet)) * chrochet, false, len(keyframes) + 1)]
				if event.pressed == false and event.button_index == 2:
					
					for i in range(1, len(keyframes) + 1):
						if keyframes[i-1] != [null]:
							if get_node("ScrollContainer/MarginContainer/" + str(i) + "/Button") != null:
								if inside(event.global_position, get_node("ScrollContainer/MarginContainer/" + str(i) + "/Button").rect_global_position, Vector2(20, 20)):
	#
									
									if len(selected) > 1:
										for j in selected:
											for b in keyframes:
												if b[-1] == j:
													keyframes.remove(indexof(keyframes, b))
										for j in selected:
											print(selected)
											get_node("/root/Node2D/ScrollContainer/MarginContainer").remove_child((get_node("/root/Node2D/ScrollContainer/MarginContainer/" + str(j))))
										print(len(keyframes))
										for j in keyframes:
											if get_node("/root/Node2D/ScrollContainer/MarginContainer/" + str(j[-1])) != null:
												get_node("/root/Node2D/ScrollContainer/MarginContainer/" + str(j[-1])).id = indexof(keyframes,j)+1
												get_node("/root/Node2D/ScrollContainer/MarginContainer/" + str(j[-1])).set_name(str(indexof(keyframes,j)+1))
												j[-1] = indexof(keyframes,j)+1
									else:
										get_node("/root/Node2D/ScrollContainer/MarginContainer").remove_child((get_node("/root/Node2D/ScrollContainer/MarginContainer/" + str(i))))
										keyframes.remove(i-1)
										print(len(keyframes))
										for j in keyframes:
											print(j[-1])
											if get_node("/root/Node2D/ScrollContainer/MarginContainer/" + str(j[-1])) != null:
												get_node("/root/Node2D/ScrollContainer/MarginContainer/" + str(j[-1])).id = indexof(keyframes,j)+1
												get_node("/root/Node2D/ScrollContainer/MarginContainer/" + str(j[-1])).set_name(str(indexof(keyframes,j)+1))
												j[-1] = indexof(keyframes,j)+1
												print(j[-1])
									for j in range(1,9):
										get_node("note" + str(j)).modulate = Color(1,1,1)
									selected = []
									selpath = []
									print(keyframes)
									break
					refresh()
	#			if event.pressed == true and event.button_index == 1 and !event.doubleclick:
	#				for i in range(1, len(keyframes) + 1):
	#					if get_node("BG/Layer/" + str(i) + "/Button") != null:
	#						if inside(event.rect_position, get_node("BG/Layer/" + str(i) + "/Button").rect_rect_position, Vector2(20, 20)):
	#							the = true
	#							break
	#			the = false
	else:
		if Input.is_action_just_pressed('exit'):
			get_tree().quit()
	#
func _on_X_text_changed(new_text):
	for i in selected:
		if keyframes[i-1] != [null]:
			var kf=keyframes[i-1]
			kf[3] = float(new_text)


func _on_Y_text_changed(new_text):
	for i in selected:
		if keyframes[i-1] != [null]:
			var kf=keyframes[i-1]
			kf[4] = float(new_text)


func _on_Angle_text_changed(new_text):
	for i in selected:
		if keyframes[i-1] != [null]:
			var kf=keyframes[i-1]
			kf[5] = float(new_text)

func _on_dir_text_changed(new_text):
	for i in selected:
		if keyframes[i-1] != [null]:
			var kf=keyframes[i-1]
			kf[6] = float(new_text)


func _on_alpha_text_changed(new_text):
	for i in selected:
		if keyframes[i-1] != [null]:
			var kf=keyframes[i-1]
			kf[7] = float(new_text)
func _on_Angle_text_entered(h):
	print('j')
	get_node("Panel/TabContainer/Values/Angle/LineEdit").release_focus()



func _on_Y_text_entered(h):
	get_node("Panel/TabContainer/Values/Y/LineEdit").release_focus()



func _on_X_text_entered(h):
	get_node("Panel/TabContainer/Values/X/LineEdit").release_focus()
	
func _on_dir_text_entered(h):
	get_node("Panel/TabContainer/Values/Direction/LineEdit").release_focus()



func _on_alpha_text_entered(h):
	get_node("Panel/TabContainer/Values/Alpha/LineEdit").release_focus()
	

func initx(input):
	get_node("Panel/TabContainer/Values/X/LineEdit").text = str(input)

func inity(input):
	get_node("Panel/TabContainer/Values/Y/LineEdit").text = str(input)

func initangle(input):
	get_node("Panel/TabContainer/Values/Angle/LineEdit").text = str(input)

func initdir(input):
	get_node("Panel/TabContainer/Values/Direction/LineEdit").text = str(input)

func initalpha(input):
	get_node("Panel/TabContainer/Values/Alpha/LineEdit").text = str(input)
func inittype(input):
	get_node('Panel/TabContainer/Values/Type/OptionButton').select(get_node('Panel/TabContainer/Values/Type/OptionButton').get_item_index(input))
func inittwn(input):
	get_node('Panel/TabContainer/Values/Tween/OptionButton').select(get_node('Panel/TabContainer/Values/Tween/OptionButton').get_item_index(input))




func _on_tween_item_selected(index):
	for i in selected:
		keyframes[i-1][9] = transitions[index]
		print(keyframes[i-1][9])


func _on_type_item_selected(index):
	for i in selected:
		keyframes[i-1][8] = types[index]
		print(keyframes[i-1][8])





func _on_Button_button_up():
	filedata = keyframes
	$"Panel/TabContainer/Save or load/Save/FileDialog".popup()


func _on_FileDialog_file_selected(path):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(to_json(filedata))
	file.close()


func _on_Open_button_up():
	$"Panel/TabContainer/Save or load/Open/FileDialog".popup()
func refresh():
	for j in range(1,9):
		get_node("note" + str(j) + '/rotate').visible = false
		get_node("note" + str(j) + '/dirrotate').visible = false
		get_node("note" + str(j) + '/HScrollBar').visible = false
		get_node("note" + str(j)).self_modulate = Color(1,1,1,0.5)
		for i in selected:
			if keyframes[i-1][1] == j:
				get_node("note" + str(j) + '/rotate').visible = true
				get_node("note" + str(j) + '/dirrotate').visible = true
				get_node("note" + str(j) + '/HScrollBar').visible = true
				get_node("note" + str(j)).self_modulate = Color(1,1,1)
		get_tween(j).stop_all()
		get_tween(j).remove_all()

func _on_FileDialog2_file_selected(path):
	var file = File.new()
	if file.file_exists(path):
		file.open(path,File.READ)
		var data = JSON.parse(file.get_as_text())
		for i in keyframes:
			if i != [null]:
				get_node("ScrollContainer/MarginContainer").remove_child((get_node("ScrollContainer/MarginContainer/" + str(i[1]))))
		selected = []
		keyframes = data.result
		print(keyframes)
		if keyframes != null:
			for i in keyframes:
				if i != [null]:
					makeKeyframe(i[1], i[0], false, indexof(keyframes, i) + 1, i, i[2])


func _on_lua_button_up():
	get_node('Panel/TabContainer/Export/Button/FileDialog2').popup()


func _on_lua_file_selected(path):
	var luastring = ''
	for i in keyframes:
		if i != [null]:
			if i[1] > 0 and i[1] < 9:
				luastring = luastring + "notetime = " + str(i[0]) + " * 0.5\nif notetime <= ballssimulatorroblox + 3 then\nif notetime >= lastconductorpos then\nnoteTweenX('balls" + str(i[1]-1) + "1', " + str(i[1]-1) + ", ogposx" + str(i[1]-1) + ' + ' + str(i[3] * 0.7) + ", " + str(i[2]) + ", '" + get_str(i[8], i[9]) + "')\nnoteTweenY('balls" + str(i[1]-1) + "2', " + str(i[1]-1) + ", ogposy" + str(i[1]-1) + ' + (' + str(i[4]) + " * (thecool[downscroll] / 0.7)), " + str(i[2]) + ", '" + get_str(i[8], i[9]) + "')\nnoteTweenAngle('balls" + str(i[1]-1) + "3', "+ str(i[1]-1) + ", " + str(i[5]) + " * (thecool[downscroll] / 0.7), " + str(i[2]) + ", '" + get_str(i[8], i[9]) + "')\nnoteTweenDirection('balls" + str(i[1]-1) + "4', " + str(i[1]-1) + ", (" +  str(i[6]) + " * (-thecool[downscroll]) / 0.7) + thecool2[downscroll], " + str(i[2]) + ", '" + get_str(i[8], i[9]) + "')\nnoteTweenAlpha('balls" + str(i[1]-1) + "5', " + str(i[1]-1) + ", " + str(i[7]) + ", " + str(i[2]) + ", '" + get_str(i[8], i[9]) + "')\nend\nend\n"
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string("thecool={ [true]=-0.7, [false]=0.7 }\nthecool2={ [true]=0, [false]=180 }\nlastConductorPos = 0\nfunction onSongStart()\nogposx0 = getPropertyFromGroup('opponentStrums', 0, 'x')\nogposy0 = getPropertyFromGroup('opponentStrums', 0, 'y');\nogposx1 = getPropertyFromGroup('opponentStrums', 1, 'x')\nogposy1 = getPropertyFromGroup('opponentStrums', 1, 'y');\n	ogposx2 = getPropertyFromGroup('opponentStrums', 2, 'x');\n	ogposy2 = getPropertyFromGroup('opponentStrums', 2, 'y');\n	ogposx3 = getPropertyFromGroup('opponentStrums', 3, 'x');\n	ogposy3 = getPropertyFromGroup('opponentStrums', 3, 'y');\n	ogposx4 = getPropertyFromGroup('playerStrums', 0, 'x');\n	ogposy4 = getPropertyFromGroup('playerStrums', 0, 'y');\n	ogposx5 = getPropertyFromGroup('playerStrums', 1, 'x');\n	ogposy5 = getPropertyFromGroup('playerStrums', 1, 'y');\n	ogposx6 = getPropertyFromGroup('playerStrums', 2, 'x');\n	ogposy6 = getPropertyFromGroup('playerStrums', 2, 'y');\n	ogposx7 = getPropertyFromGroup('playerStrums', 3, 'x');\n	ogposy7 = getPropertyFromGroup('playerStrums', 3, 'y');\nend\nfunction onUpdate(elapsed)\n\n	ballssimulatorroblox = getSongPosition();\n" + luastring + 'lastconductorpos = ballssimulatorroblox\nend\nfunction onUpdatePost(elapsed)\nnoteCount = getProperty("notes.length")\nfor i = 0, noteCount-1 do\nnoteData = getPropertyFromGroup("notes", i, "noteData")\nif (getPropertyFromGroup("notes", i, "mustPress")) and (getPropertyFromGroup("notes", i, "isSustainNote")) then\nsetPropertyFromGroup("notes", i, "angle", getPropertyFromGroup("playerStrums", noteData, "direction") - 90)\nelseif (getPropertyFromGroup("notes", i, "isSustainNote")) then\nsetPropertyFromGroup("notes", i, "angle", getPropertyFromGroup("opponentStrums", noteData, "direction") - 90)\nend\nif (noteData >= 4) and (not getPropertyFromGroup("notes", i, "isSustainNote")) then\nsetPropertyFromGroup("notes", i, "angle", getPropertyFromGroup("playerStrums", noteData, "angle"))\nelseif (not getPropertyFromGroup("notes", i, "isSustainNote")) then\nsetPropertyFromGroup("notes", i, "angle", getPropertyFromGroup("opponentStrums", noteData, "angle"))\nend\nend\nend\n--generated by methewhenmethes modchart editor')
	file.close()
	print("thecool = []\nthecool[true] = -1\nthecool[false] = 1\nthecool2 = []\nthecool[true] = 180\nthecool[false] = 0\nlastConductorPos = 0\nfunction onSongStart()\nogposx0 = getPropertyFromGroup('opponentStrums', 0, 'x')\nogposy0 = getPropertyFromGroup('opponentStrums', 0, 'y');\nogposx1 = getPropertyFromGroup('opponentStrums', 1, 'x')\nogposy1 = getPropertyFromGroup('opponentStrums', 1, 'y');\n	ogposx2 = getPropertyFromGroup('opponentStrums', 2, 'x');\n	ogposy2 = getPropertyFromGroup('opponentStrums', 2, 'y');\n	ogposx3 = getPropertyFromGroup('opponentStrums', 3, 'x');\n	ogposy3 = getPropertyFromGroup('opponentStrums', 3, 'y');\n	ogposx4 = getPropertyFromGroup('playerStrums', 0, 'x');\n	ogposy4 = getPropertyFromGroup('playerStrums', 0, 'y');\n	ogposx5 = getPropertyFromGroup('playerStrums', 1, 'x');\n	ogposy5 = getPropertyFromGroup('playerStrums', 1, 'y');\n	ogposx6 = getPropertyFromGroup('playerStrums', 2, 'x');\n	ogposy6 = getPropertyFromGroup('playerStrums', 2, 'y');\n	ogposx7 = getPropertyFromGroup('playerStrums', 3, 'x');\n	ogposy7 = getPropertyFromGroup('playerStrums', 3, 'y');\nend\nfunction onUpdate(elapsed)\n\n	ballssimulatorroblox = getSongPosition();\n" + luastring + 'lastconductorpos = ballssimulatorroblox\nend')
func _on_bpm_text_entered(new_text):

	bpm = float(new_text)
	_ready2()
	remove_child(get_node("Popup"))
