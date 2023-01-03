extends Node2D
#Escoge

#Trivia iteration
var option
var round_limit = 10

#JSON Data
var file = File.new()
var json
var trivia_data
var answer

#Other
var time = 0
var handle_selection = true
const SELECTION_WAIT_TIME = 0.8

#Colors
var correct_color = Color(0.12,1,0)
var incorrect_color = Color(1,0,0.91)
var reset_color = Color(1,1,1)

const NORMAL_FONT_SIZE = 49
const SMALL_FONT_SIZE = 40

var scoreSum = 100

func initGame():
	visible = true
	setTriviaLabelsText()
	get_node("selectionWait").wait_time = SELECTION_WAIT_TIME


#From signals, choice election
func _on_opcionButton1_pressed():
	optionAction(1)
	
func _on_opcionButton2_pressed():
	optionAction(2)

func _on_opcionButton3_pressed():
	optionAction(3)

func _on_opcionButton4_pressed():
	optionAction(4)
		
func optionAction(option_num):
	if handle_selection:
		handle_selection = false
		option = option_num
		#Answar good and finish
		if option == answer:
				music.playGood()
				getOpcionButtonByNumber(option_num).modulate = correct_color
				get_node("mensaje").set_text("¡Correcto!")
				Global.actual_level_score += scoreSum
		else:
			music.playWrong()
			getOpcionButtonByNumber(option_num).modulate = incorrect_color
			getOpcionButtonByNumber(int(answer)).modulate = correct_color
			get_node("mensaje").set_text("Incorrecto")
		Global.max_actual_level_score += scoreSum
		get_node("mensaje").visible = false
		get_node("selectionWait").start()
	
func setTriviaLabelsText():
	if Global.trivia_point == 3 and Global.round_number == 2 and Global.mountain == 1:
		setTitleSize(SMALL_FONT_SIZE)
		
	trivia_data = Global.trivia_data
	var str_trivia_point = str(Global.trivia_point)
	var str_round_number = str(Global.round_number)
	get_node("pregunta/Control/pregunta label").set_text(trivia_data[str_trivia_point][str_round_number]["pregunta"])
	get_node("button1/Control/opcion1").set_text(trivia_data[str_trivia_point][str_round_number]["opciones"][0])
	get_node("button2/Control/opcion2").set_text(trivia_data[str_trivia_point][str_round_number]["opciones"][1])
	get_node("button3/Control/opcion3").set_text(trivia_data[str_trivia_point][str_round_number]["opciones"][2])
	get_node("button4/Control/opcion4").set_text(trivia_data[str_trivia_point][str_round_number]["opciones"][3])
	answer = trivia_data[str_trivia_point][str_round_number]["respuesta"]
	
func getOpcionButtonByNumber(number):
	var node
	match number:
		1:
			node = get_node("button1/Control/opcionButton1")
		2:
			node = get_node("button2/Control/opcionButton2")
		3:
			node = get_node("button3/Control/opcionButton3")
		4:
			node = get_node("button4/Control/opcionButton4")
	return node

func resetOptionsModulate():
	for number in range(1,5):
		getOpcionButtonByNumber(number).modulate = reset_color

func _on_selectionWait_timeout():
	#setTriviaLabelsText()
	resetOptionsModulate()
	handle_selection = true
	visible = false
	get_node("mensaje").visible = false
	print("time finished")
	
	
	get_tree().get_root().get_node("trivia_main").roundFinished()
	#print("finished")

func setTitleSize(size):
	get_node("pregunta/Control/pregunta label").get("custom_fonts/font").set_size(size)

