extends Node2D

var ordenada: String
var desordenada: String
var pregunta
var trivia_data

var scoreSum = [200,170,50]
var incorrect_count = 0

var advance_idx: int = 0
var selected_btn
var correct = false
var finished = false

var incorrect_color = Color("da2020")
var correct_color = Color("2ada20")
var reset_color = Color(1,1,1)
var transparent_color = Color(1,1,1,0)

onready var answerRow: Node = get_node("letrasOrdenadas")
onready var btnsUpRow: Node = get_node("letrasDesordenadas/fila1")
onready var btnsDownRow: Node = get_node("letrasDesordenadas/fila2")

var handle_selection = true

func initGame():
	deleteLetters()
	$mensaje.visible = false
	visible = true
	finished = false
	setData()
	updateLetterBtns()
	#print(get_tree())
	#print_tree_pretty()

func setData():
	#test()
	trivia_data = Global.trivia_data
	pregunta = trivia_data[str(Global.trivia_point)][str(Global.round_number)]["pregunta"]
	desordenada = trivia_data[str(Global.trivia_point)][str(Global.round_number)]["desorden"]
	ordenada = trivia_data[str(Global.trivia_point)][str(Global.round_number)]["orden"]
	get_node("pregunta/pregunta label").set_text(pregunta)
	print("Ordenada: ",ordenada)
	print("Desordenada: ",desordenada)

func updateLetterBtns():
	var orderedLetters = ordenada.length()
	var unorderedLetters = ordenada.length()
	for idx in unorderedLetters:
		addBigLetter(desordenada[idx])
	
func deleteLetters():
	for idx in answerRow.get_child_count():
		answerRow.get_child(idx).queue_free()
	for idx in btnsUpRow.get_child_count():
		btnsUpRow.get_child(idx).queue_free()
	for idx in btnsDownRow.get_child_count():
		btnsDownRow.get_child(idx).queue_free()
	

func test():
	Global.trivia_point = 1
	Global.round_number = 1
	

func addSmallLetter(letter):
	var btn = preload ("res://letterButton.tscn").instance()
	btn.get_node("Label").set_text(letter)
	answerRow.add_child (btn)
	
func addBigLetter(letter):
	var btnLimit = 5
	var btn = preload ("res://letterButtonBig.tscn").instance()
	btn.get_node("Button").connect("btnPressed",self,"letterPressed")
	btn.get_node("Label").set_text(letter)
	btn.name = letter
	if btnsUpRow.get_child_count() < btnLimit:
		btnsUpRow.add_child (btn)
	else:
		btnsDownRow.add_child (btn)

func letterPressed(letter,button):
		if handle_selection:
			handle_selection = false
			print(letter)
			if ordenada.find(letter,advance_idx) == advance_idx:
				music.playGood()
				button.modulate = correct_color
				selected_btn = button
				addSmallLetter(letter)
				advance_idx += 1
				correct = true
				get_node("correctWait").start()

				if advance_idx == ordenada.length():
					setRoundScore()
					finished = true
			else:
				music.playWrong()
				incorrect_count += 1
				button.modulate = incorrect_color
				selected_btn = button
				$mensaje.set_text("Incorrecto")
				$mensaje.visible = true
				get_node("incorrectWait").start()
				correct = false
			
	
func setRoundScore():
	Global.max_actual_level_score += scoreSum[0]
	if incorrect_count == 0:
		Global.actual_level_score += scoreSum[0]
	elif incorrect_count > 0 and incorrect_count <= 2:
		Global.actual_level_score += scoreSum[1]
	else:
		Global.actual_level_score += scoreSum[2]


func _on_selectionWait_timeout():
	$mensaje.visible = false
	handle_selection = true
	selected_btn.modulate = reset_color
	if correct:
		#selected_btn.queue_free()
		selected_btn.modulate = transparent_color
		if finished:
			finished = false
			correct = false
			visible = false
			$mensaje.visible = false
			advance_idx = 0
			deleteLetters()
			get_tree().get_root().get_node("trivia_main").roundFinished()
	
	
