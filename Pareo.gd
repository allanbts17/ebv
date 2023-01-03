extends Node2D


var trivia_data
var pregunta
var izquierda: Array
var derecha: Array
var word_map = {}
var scoreSum = [300,150,50]
var incorrect_count = 0

var select_color = Color("0016ff")
var incorrect_color = Color("ff0d0d")
var correct_color = Color("2cff00")
var unselect_color = Color(1,1,1)

var second_button
var side_selected
var one_word_selected = false

#correct
var actual_side
var last_button
var pending_button = false

var incorrect_words = []
var correct_words

var incorrect_message = "Incorrecto"
var correct_message = "¡Correcto!"

var word_column_length
var word_column_count = 0

var handle_pressed = true

onready var left_container: Node = get_node("izquierda")
onready var right_container: Node = get_node("derecha")

func initGame():
	initClear()
	$mensaje.visible = false
	visible = true
	setData()
	
func initClear():
	left_container.get_child(0).queue_free()

func setData():
	trivia_data = Global.trivia_data
	pregunta = "Relaciona las columnas"
	izquierda = trivia_data[str(Global.trivia_point)][str(Global.round_number)]["izquierda"]
	derecha = trivia_data[str(Global.trivia_point)][str(Global.round_number)]["derecha"]
	get_node("pregunta/pregunta label").set_text(pregunta)
	dictFill()
	
func dictFill():
	for idx in range(izquierda.size()):
		word_map[izquierda[idx]] = derecha[idx]
	
	#Add words
	derecha.shuffle()
	izquierda.shuffle()
	word_column_length = izquierda.size()
	for idx in range(izquierda.size()):
		addLeftWord(izquierda[idx])
		addRightWord(derecha[idx])
	#print(word_map)
	

func addLeftWord(word):
	var btn = preload ("res://palabraPareo.tscn").instance()
	btn.get_node("MarginContainer/Label").set_text(word)
	btn.connect("btnPressed",self,"wordPressed")
	left_container.add_child (btn)

func addRightWord(word):
	var btn = preload ("res://palabraPareo.tscn").instance()
	btn.get_node("MarginContainer/Label").set_text(word)
	btn.connect("btnPressed",self,"wordPressed")
	right_container.add_child (btn)

func selectButton(button):
	button.modulate = select_color
	last_button = button
	
func unselectButton(button):
	button.modulate = unselect_color

func correctButtons(buttonOne,buttonTwo):
	buttonOne.modulate = correct_color
	buttonTwo.modulate = correct_color
	buttonOne.get_parent().selected = true
	buttonTwo.get_parent().selected = true
	
func incorrectButtons(buttonOne,buttonTwo):
	buttonOne.modulate = incorrect_color
	buttonTwo.modulate = incorrect_color
	$mensaje.set_text(incorrect_message)
	$mensaje.visible = true
	incorrect_words = [buttonOne,buttonTwo]
	get_node("incorrectWait").start()
	handle_pressed = false
	
func wordPressed(word,button,selected):
	print(word," selected: ",selected)
	#selected_word = button_container
	if not selected and handle_pressed:
		actual_side = button.get_parent().get_parent().name
		
		#si hay un boton ya seleccionado y pendiente
		if pending_button:
			var last_button_side = last_button.get_parent().get_parent().name
			#Son de la misma columna?
			if last_button_side == actual_side:
				music.playButton()
				unselectButton(last_button)
				selectButton(button)
			else:
				pending_button = false
				if compareWords(word):
					music.playGood()
					correctButtons(button,last_button)
					word_column_count += 1
					ifWin()
				else:
					incorrect_count += 1
					music.playWrong()
					incorrectButtons(button,last_button)
		else:
			music.playButton()
			selectButton(button)
			pending_button = true
				
		
	

func ifWin():
	if word_column_count == word_column_length:
		word_column_count=0
		setRoundScore()
		get_node("correctWait").start()
		

func clearWords():
	for idx in left_container.get_child_count():
		left_container.get_child(idx).queue_free()
		right_container.get_child(idx).queue_free()

func compareWords(word):
	var other_side_word = last_button.get_node("Label").get_text()
	print(other_side_word,", ",word)
	print(actual_side)
	print(word_map)
	if actual_side == "derecha":
		return word_map[other_side_word] == word
	else:
		return word_map[word] == other_side_word

func setRoundScore():
	Global.max_actual_level_score += scoreSum[0]
	if incorrect_count == 0:
		Global.actual_level_score += scoreSum[0]
		print("max")
	elif incorrect_count > 0 and incorrect_count <= 2:
		Global.actual_level_score += scoreSum[1]
		print("parcial")
	else:
		Global.actual_level_score += scoreSum[2]
		print("less")
	incorrect_count = 0

func _on_incorrectWait_timeout():
	$mensaje.visible = false
	incorrect_words[0].modulate = unselect_color
	incorrect_words[1].modulate = unselect_color
	incorrect_words.clear()
	handle_pressed = true


func _on_correctWait_timeout():
	clearWords()
	visible = false
	$mensaje.visible = false
	get_tree().get_root().get_node("trivia_main").roundFinished()
