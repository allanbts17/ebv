extends Node2D

#JSON Data
var file = File.new()
var json
var trivia_data

var gameNode
var test

var scene = "res://montanas.tscn"

func _ready():
	get_node("Escoge").visible = false
	get_node("Rostro").visible = false
	get_node("Ordena").visible = false
	get_node("Pareo").visible = false
	get_node("nivelTerminado").visible = false
	playTriviaSong()
	setTriviaData()
	initDialogue()
	
func playTriviaSong():
	music.stop()
	music.setTriviaSong()
	music.play()
	
func playGeneralSong():
	music.stop()
	music.setGeneralSong()
	music.play()
	
func setTriviaData():
	file.open("res://recursos/trivia/reactivos/mountain"+str(Global.mountain)+".json", file.READ)
	json = file.get_as_text()
	Global.trivia_data = JSON.parse(json).result
	trivia_data = Global.trivia_data
	file.close()

func initDialogue():
	var mountain = Global.mountain
	var point = Global.trivia_point
	var new_dialog = Dialogic.start(Global.dialogos[mountain][point],false)
	add_child(new_dialog)
	new_dialog.connect('timeline_end',self,'dialogueEnd')

func dialogueEnd(name):
	get_node("TouchScreenButton").visible = false
	selectGame()
	
func selectGame():
	var gameType = trivia_data[str(Global.trivia_point)][str(Global.round_number)]["tipo"]
	match gameType:
		"Identifica el rostro":
			gameNode = "Rostro"
		"Opción múltiple":
			gameNode = "Escoge"
		"Pareo":
			gameNode = "Pareo"
		"Completa":
			gameNode = "Escoge"
		"Ordena la palabra":
			gameNode = "Ordena"
	#get_node("Label").set_text("funciona")
	#get_node("Label").set_text(gameNode)
	get_node(gameNode).initGame()

func endMountainDialogue():
	#get_node("dialogueBackground").visible = true
	#handle_pressed = false
	#Dialogic.set_variable("name",Global.player_name)
	#Dialogic.save_definitions()
	#print(Dialogic.get_variable("name"))
	var timeline_name = Global.end_mountain_dialogs[Global.mountain]
	var new_dialog = Dialogic.start(timeline_name,false)
	add_child(new_dialog)
	new_dialog.connect('timeline_end',self,'topMountainDialogueEnd')
	
func topMountainDialogueEnd(name):
	levelSucess()
	get_node("TouchScreenButton").visible = false
	get_node("nivelTerminado").visible = true
	
func roundFinished():
	Global.round_number += 1
	if Global.round_number == 2:
		selectGame()
	else:
		ifLevelPassed()

func ifLevelPassed():
	var min_score = Global.max_actual_level_score/2
	var actual_score = Global.actual_level_score
	if actual_score < min_score:
		levelFail(min_score)
		get_node("nivelTerminado").visible = true
	else:
		if Global.trivia_point == 5:
			music.playTop()
			get_node("TouchScreenButton").visible = true
			endMountainDialogue()
		else:
			levelSucess()
			get_node("nivelTerminado").visible = true
			
	

func levelSucess():
	var record_text = "Récord: "+str(getPerLevelScore())
	var score_text = "Puntaje: "+str(Global.actual_level_score)
	get_node("nivelTerminado/sucess").visible = true
	get_node("nivelTerminado/fail").visible = false
	get_node("nivelTerminado/sucess/record").set_text(record_text)
	get_node("nivelTerminado/sucess/score").set_text(score_text)
	#Updating score
	if Global.actual_level_score > getPerLevelScore():
		setPerLevelScore(Global.actual_level_score)
		updateGeneralScore()
	Global.max_actual_level_score = 0
	Global.actual_level_score = 0
	unlockNextLevel()
	music.playVictory()
	
func levelFail(min_score):
	var min_text = "Mínimo: "+str(min_score)
	var score_text = "Puntaje: "+str(Global.actual_level_score)
	get_node("nivelTerminado/sucess").visible = false
	get_node("nivelTerminado/fail").visible = true
	get_node("nivelTerminado/fail/score").set_text(score_text)
	get_node("nivelTerminado/fail/min").set_text(min_text)
	Global.max_actual_level_score = 0
	Global.actual_level_score = 0
	music.playDefeat()

func getPerLevelScore():
	var mountain = str(Global.mountain)
	var level = str(Global.trivia_point)
	return Global.sav_data["progress"]["per_level_score"][mountain][level]
	
func setPerLevelScore(score):
	var mountain = str(Global.mountain)
	var level = str(Global.trivia_point)
	Global.sav_data["progress"]["per_level_score"][mountain][level] = score
	Global.setSavData()
	Global.update()

func updateGeneralScore():
	var score = 0
	for mountain in range(1,6):
		for level in range(1,6):
			score += Global.sav_data["progress"]["per_level_score"][str(mountain)][str(level)]
		
	Global.sav_data["progress"]["score"] = score
	Global.setSavData()
	Global.update()

func unlockNextLevel():
	#Revisar si el siguiente está desbloqueado
	var max_unlocked_level = Global.sav_data["progress"]["unlocked"]
	var actual_level = [Global.mountain,Global.trivia_point]
	print("max_unlocked_level: ",max_unlocked_level," actual_level: ",actual_level)
	print("true? ",max_unlocked_level == actual_level)
	print("point true? ",max_unlocked_level[0] == actual_level[0],max_unlocked_level[1] == actual_level[1])
	if max_unlocked_level[0] == actual_level[0] and max_unlocked_level[1] == actual_level[1]:
		Global.sav_data["progress"]["unlocked"] = addToLevelArray(actual_level)
		Global.setSavData()

func addToLevelArray(array):
	print("normal: ",array)
	if array != [5,5]:
		array[1] += 1
		if array[1] > 5:
			array[1] = 1
			array[0] += 1
	print("added: ",array)
	return array

func _on_return_button_down():
	var scalar = 0.96
	$return.rect_scale = Vector2(scalar,scalar)


func _on_return_button_up():
	Global.round_number = 1
	music.playButton()
	playGeneralSong()
	get_tree().change_scene("res://montanas.tscn")


func _on_TouchScreenButton_released():
	playGeneralSong()
	Global.round_number = 1
	get_tree().change_scene(scene)
