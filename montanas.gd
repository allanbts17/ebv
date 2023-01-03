extends Node2D

export (PackedScene) var scene

onready var tween: Tween = get_node("montanas/Tween")
onready var montanas: Node2D = get_node("montanas")
onready var leftArrow = get_node("arrows/leftArrow")
onready var rightArrow = get_node("arrows/rightArrow")
onready var actual_mountain_title = get_node("nombre_montana/Label")
const NORMAL_FONT_SIZE = 92
const SMALL_FONT_SIZE = 70
const PRESSED_ARROW_MOVE  = Vector2(7,0)

var handle_pressed = true

var move_duration = 0.3
var transition_type = Tween.TRANS_QUAD
var ease_type = Tween.EASE_OUT

var mountain_names = ["Monte Moriah","Monte Horeb","Monte Sinaí","Monte Carmelo","Monte de los Olivos"]
var mountain_number = 0

func _ready():
	mountain_number = Global.mountain - 1
	if mountain_number == 4:
		setTitleSize(SMALL_FONT_SIZE)
	else:
		setTitleSize(NORMAL_FONT_SIZE)
	montanas.position = Vector2(-720*mountain_number,0) 
	actual_mountain_title.set_text(mountain_names[mountain_number])
	get_node("TouchScreenButton").visible = true
	setScoreText()
	updateTriviaPointsLock()
	firstTime()

func updateTriviaPointsLock():
	var limit = Global.sav_data["progress"]["unlocked"]
	#From 1 to limit
	for mountain in range(1,6):
		for point in range(1,6):
			if mountain < limit[0]:
				setTriviaPointLock(mountain,point,false)
			elif mountain == limit[0]:
				if point <= limit[1]:
					setTriviaPointLock(mountain,point,false)
				else:
					setTriviaPointLock(mountain,point,true)
			else:
				setTriviaPointLock(mountain,point,true)

func setTriviaPointLock(mountain,point,lock):
	var path
	if lock:
		path = "res://recursos/montanas/puntoAzul.png"
	else:
		path = "res://recursos/montanas/puntoVerde.png"
	var trivia_point = get_node("montanas/montana"+str(mountain)+"/puntoTrivia"+str(point))
	var texture = load(path)
	trivia_point.set_texture(texture)
	

func setScoreText():
	var text = "Puntaje: " + str(Global.score)
	get_node("score/Label").set_text(text)
	
func firstTime():
	if Global.first_time:
		#music.playSaludo()
		get_node("dialogueBackground").visible = true
		handle_pressed = false
		Dialogic.set_variable("name",Global.player_name)
		Dialogic.save_definitions()
		print(Dialogic.get_variable("name"))
		var timeline_name
		print("First: ", Global.sav_data["setting"]["first"])
		if Global.sav_data["setting"]["first"] == true:
			Global.sav_data["setting"]["first"] = false
			Global.setSavData()
			timeline_name = 'PresentacionDePipe'
		else:
			timeline_name = 'pipeDeNuevo'
		var new_dialog = Dialogic.start(timeline_name,false)
		Global.first_time = false
	
		add_child(new_dialog)
		new_dialog.connect('timeline_end',self,'pipePresentationFinished')
	
func pipePresentationFinished(name):
	handle_pressed = true
	get_node("dialogueBackground/AnimationPlayer").play("dialogue_end")
	
	#print("sucess: ",name)

func moveForward():
	var init_pos = montanas.get_position()
	var final_pos = init_pos + Vector2(-720,0)
	tween.interpolate_property(montanas,"position",init_pos,final_pos,0.8,transition_type,ease_type)
	tween.start()
	
func moveReverse():
	var init_pos = montanas.get_position()
	var final_pos = init_pos + Vector2(720,0)
	tween.interpolate_property(montanas,"position",init_pos,final_pos,0.8,transition_type,ease_type)
	tween.start()
	

func setTitleSize(size):
	actual_mountain_title.get("custom_fonts/font").set_size(size)

func _on_puntoTrivia1_pressed():
		initTriviaGame(1)

func _on_puntoTrivia2_pressed():
		initTriviaGame(2)

func _on_puntoTrivia3_pressed():
		initTriviaGame(3)

func _on_puntoTrivia4_pressed():
		initTriviaGame(4)

func _on_puntoTrivia5_pressed():
		initTriviaGame(5)
	
func initTriviaGame(trivia_point):
	var limit = Global.sav_data["progress"]["unlocked"]
	print("limit: ",limit)
	print("mountain, level: ",[Global.mountain,trivia_point])
	var open_game = false
	
	if Global.mountain < limit[0]:
		open_game = true
	elif Global.mountain == limit[0]:
		if trivia_point <= limit[1]:
			open_game = true
		else:
			open_game = false
	else:
		open_game = false
		
	if open_game and handle_pressed:
		Global.trivia_point = trivia_point
		music.playButton()
		music.stop()
		get_tree().change_scene_to(scene)
	
	
func verifyMountainNumber():
	if mountain_number > 4:
		mountain_number = 4
		return false
	elif mountain_number < 0:
		mountain_number = 0
		return false
	else:
		return true

func _on_rightArrow_pressed():
	if handle_pressed:
		music.playButton()
		rightArrow.position += PRESSED_ARROW_MOVE
		mountain_number += 1
		if verifyMountainNumber():
			handle_pressed = false
			moveForward()

func _on_leftArrow_pressed():
	if handle_pressed:
		music.playButton()
		leftArrow.position -= PRESSED_ARROW_MOVE
		mountain_number -= 1
		if verifyMountainNumber():
			handle_pressed = false
			moveReverse()
			
func _on_rightArrow_released():
	rightArrow.position -= PRESSED_ARROW_MOVE

func _on_leftArrow_released():
	leftArrow.position += PRESSED_ARROW_MOVE

func _on_Tween_tween_completed(object, key):
	#print(object,", ",key)
	if mountain_number == 4:
		setTitleSize(SMALL_FONT_SIZE)
	else:
		setTitleSize(NORMAL_FONT_SIZE)
	actual_mountain_title.set_text(mountain_names[mountain_number])
	Global.mountain = mountain_number+1
	handle_pressed = true



func _on_AnimationPlayer_animation_finished(anim_name):
	get_node("dialogueBackground").visible = false
	get_node("TouchScreenButton").visible = false


func _on_return_button_down():
	var scalar = 0.96
	$return.rect_scale = Vector2(scalar,scalar)


func _on_return_button_up():
	music.playButton()
	get_tree().change_scene("res://main.tscn")
