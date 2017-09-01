extends Patch9Frame

var menu = false
var open = false

var currentScene = null

var up = false
var down = false
var left = false
var right = false
var spacePressed = false
var chaptersOpen = true
var chapterIsChanging = false

var in_chapter_box = false

var currentLabel = 0
var currentChapLabel = 0
var lessonPlanPage = 0
var labels
var chapLabels
var start_pos_select

var pointer
var chapSelect
var player_pos
var lesson_plan_toptext
var lesson_plan_bottomtext
var lesson_plan_bottom_size

onready var chapterNode = get_node("chapter_menu")
onready var confirmationNode = get_node("confirmation")
onready var lessonPlanNode = get_tree().get_current_scene().get_node("lesson_plan")

func setScene(scene):
	#clean up the current scene
	currentScene.queue_free()
	#load the file passed in as the param "scene"
	var s = ResourceLoader.load(scene)
	#create an instance of our scene
	currentScene = s.instance()
	# add scene to root
	get_tree().get_root().add_child(currentScene)

func _ready():
	currentScene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1)
	set_process_unhandled_key_input(true)
	set_fixed_process(true)
	labels = get_node("Labels").get_children()
	pointer = get_node("selector")
	chapSelect = get_node("chapter_select")
	chapSelect.set_hidden(true)
	chapLabels = get_node("chapter_menu").get_children()
	pointer_update()
	set_as_toplevel(true)
	if get_tree().get_current_scene().has_node("lesson_plan"):
		#lesson_plan_toptext = get_tree().get_current_scene().lesson_plan_toptext
		lesson_plan_bottomtext = get_tree().get_current_scene().lesson_plan_bottomtext
		lesson_plan_bottom_size = lesson_plan_bottomtext.size()

	

func _handle_interaction():
	if currentLabel == 0: #chapters label
		player_pos = get_tree().get_current_scene().get_node("Player").get_pos()
		chapterNode.set_pos(Vector2(player_pos.x-100, player_pos.y-76))
		chapSelect.set_pos(Vector2(player_pos.x-3, player_pos.y-60))
		start_pos_select = chapSelect.get_pos()
		chapterNode.set_hidden(false)
		chapSelect.set_hidden(false)
		chapSelect.set_as_toplevel(true)
		in_chapter_box = true
	if currentLabel == 1: #lesson plan
		if get_tree().get_current_scene().has_node("lesson_plan"):
			player_pos = get_tree().get_current_scene().get_node("Player").get_pos()
			lessonPlanNode.set_pos(Vector2(player_pos.x-100, player_pos.y-75))
			lessonPlanNode.set_hidden(false)
		else:
			print("no lesson plan in this scene") #should not reach this
		player_pos = get_tree().get_current_scene().get_node("Player").get_pos()
		
	if currentLabel == 2: # main menu - BROKEN - startup screen frozen
		menu = false
		open = false
		setScene("res://screens/main_menu/startUp.tscn")
		#get_tree().change_scene("res://screens/main_menu/startUp.tscn")
	elif currentLabel == 3: #Exit Label
		OS.get_main_loop().quit()

func _handle_chap_select():
	player_pos = get_tree().get_current_scene().get_node("Player").get_pos()
	confirmationNode.set_pos(Vector2(player_pos.x-85, player_pos.y-50))
	if currentChapLabel >= 0 and currentChapLabel < 10:
		confirmationNode.set_hidden(false)
	elif currentChapLabel == 11:
		hide_chapter_window()
		
func _handle_chapter_change():
	if currentChapLabel == 0:
		print("change to chapter: " + str(currentLabel))
	elif currentChapLabel == 1:
		print("change to chapter: " + str(currentLabel))
	elif currentChapLabel == 2:
		print("change to chapter: " + str(currentLabel))
	elif currentChapLabel == 3:
		print("change to chapter: " + str(currentLabel))
	elif currentChapLabel == 4:
		print("change to chapter: " + str(currentLabel))
	elif currentChapLabel == 5:
		print("change to chapter: " + str(currentLabel))
	elif currentChapLabel == 6:
		print("change to chapter: " + str(currentLabel))
	elif currentChapLabel == 7:
		print("change to chapter: " + str(currentLabel))
	elif currentChapLabel == 8:
		print("change to chapter: " + str(currentLabel))
	elif currentChapLabel == 9:
		print("change to chapter: " + str(currentLabel))
	elif currentChapLabel == 9:
		print("change to chapter: " + str(currentLabel))

func hide_chapter_window():
	chapSelect.set_hidden(true)
	chapterNode.set_hidden(true)
	set_hidden(true)
	get_tree().set_pause(false)
	currentChapLabel = 0
	open = false
		
		
func _fixed_process(delta):
	if confirmationNode.is_visible():
		if confirmationNode.get_node("back").is_pressed():
			confirmationNode.set_hidden(true)
		elif confirmationNode.get_node("button_enter").is_pressed() and !chapterIsChanging:
			chapterIsChanging = true
			_handle_chapter_change()
	if get_tree().get_current_scene().has_node("lesson_plan"):
		if lessonPlanNode.is_visible(): # navigate the lesson plan
			if right or lessonPlanNode.get_node("right_button").is_pressed():
				if lessonPlanPage < lesson_plan_bottom_size-1: 
					lessonPlanPage += 1
					#lessonPlanNode.get_node("intro_text").set_bbcode(lesson_plan_toptext[lessonPlanPage])
					lessonPlanNode.get_node("describing_text").set_bbcode(lesson_plan_bottomtext[lessonPlanPage])
					OS.delay_msec(150) #pause so it doesnt skip to the next screen
				right = false
			elif left or lessonPlanNode.get_node("left_button").is_pressed():
				if lessonPlanPage > 0:
					lessonPlanPage -= 1
					#lessonPlanNode.get_node("intro_text").set_bbcode(lesson_plan_toptext[lessonPlanPage])
					lessonPlanNode.get_node("describing_text").set_bbcode(lesson_plan_bottomtext[lessonPlanPage])
					OS.delay_msec(150)
				left = false 
			if spacePressed or menu:
				lessonPlanNode.set_hidden(true)
				#currentLabel = 0
				menu = false
				spacePressed = false

	if chapterNode.is_visible() and !confirmationNode.is_visible():
		if up:
			if currentChapLabel == 0:
				chapSelect.set_pos(Vector2(chapSelect.get_pos().x, chapSelect.get_pos().y + (11 * (chapLabels.size()-1))))
				currentChapLabel = chapLabels.size()-1
			else:
				chapSelect.set_pos(Vector2(chapSelect.get_pos().x, chapSelect.get_pos().y - 11))
				currentChapLabel -= 1

		if down:
			if currentChapLabel == chapLabels.size()-1:
				currentChapLabel = 0
				chapSelect.set_pos(start_pos_select)
			else:
				chapSelect.set_pos(Vector2(chapSelect.get_pos().x, chapSelect.get_pos().y + 11))
				currentChapLabel += 1
		if spacePressed:
			_handle_chap_select()
		if menu:
			hide_chapter_window()
			

	if open and !chapterNode.is_visible():
		if spacePressed:
			if get_node("chapter_menu").is_visible():
				pass
			else:
				_handle_interaction()
		
		if menu:
			set_hidden(true)
			get_tree().set_pause(false)
			open = false
		if up:
			if currentLabel == 0:
				currentLabel = labels.size()-1
			else:
				currentLabel -= 1
			pointer_update()
		if down:
			if currentLabel == labels.size()-1:
				currentLabel = 0
			else:
				currentLabel += 1
			pointer_update()
	menu = false
	up  = false
	down = false
	spacePressed = false

func pointer_update():
	pointer.set_global_pos(Vector2(pointer.get_global_pos().x, labels[currentLabel].get_global_pos().y+4))

func chap_select_update():
	chapSelect.set_global_pos(Vector2(chapSelect.get_global_pos().x, chapLabels[currentChapLabel].get_global_pos().y+16))

func _unhandled_key_input(key_event):
	if open:
		if key_event.is_action_pressed("ui_menu"):
			menu = true
		elif key_event.is_action_released("ui_menu"):
			menu = false
		if key_event.is_action_pressed("ui_down"):
			down = true
		elif key_event.is_action_released("ui_down"):
			down = false
		if key_event.is_action_pressed("ui_up"):
			up = true
		elif key_event.is_action_released("ui_up"):
			up = false
	if key_event.is_action_pressed("ui_interact"):
		spacePressed = true
	elif key_event.is_action_released("ui_interact"):
		spacePressed = false
	if key_event.is_action_pressed("ui_right"):
		right = true
	elif key_event.is_action_released("ui_right"):
		right = false
	if key_event.is_action_pressed("ui_left"):
		left = true
	elif key_event.is_action_released("ui_left"):
		left = false

func _open_menu():
	player_pos = get_tree().get_current_scene().get_node("Player").get_pos()
	set_pos(Vector2(player_pos.x-30, player_pos.y+5))
	set_hidden(false)
	get_tree().set_pause(true)
	menu = false
	open = true