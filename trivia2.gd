extends Node2D
#Rostro

var personaje
var preguntaText
var trivia_data
var scoreSum = 100

var handle_selection = true
var correct_color = Color("31f835")
var incorrect_color = Color("f83131")

func initGame():
	visible = true
	setData()

func setData():
	trivia_data = Global.trivia_data
	personaje = trivia_data[str(Global.trivia_point)][str(Global.round_number)]["rostro"]
	preguntaText = "Identifica a "+ personaje
	get_node("pregunta/pregunta label").set_text(preguntaText)
	
func buttonPressed(_personaje,btn):
	if handle_selection:
		handle_selection = false
		if personaje == _personaje:
			music.playGood()
			btn.modulate = correct_color
			$mensaje.set_text("¡Correcto!")
			Global.actual_level_score += scoreSum
		else:
			music.playWrong()
			btn.modulate = incorrect_color
			$mensaje.set_text("Incorrecto")
		$mensaje.visible = true
		Global.max_actual_level_score += scoreSum
		#For animation next
		get_node("selectionWait").start()
	


func _on_Abraham_pressed():
	var btn = get_node("buttons/Abraham")
	buttonPressed("Abraham",btn)

func _on_Jess_pressed():
	var btn = get_node("buttons/Jesus")
	buttonPressed("Jesús",btn)

func _on_MoissJoven_pressed():
	var btn = get_node("buttons/MoisesJoven")
	buttonPressed("Moisés joven",btn)

func _on_MoissViejo_pressed():
	var btn = get_node("buttons/MoisesViejo")
	buttonPressed("Moisés viejo",btn)

func _on_Elas_pressed():
	var btn = get_node("buttons/Elias")
	buttonPressed("Elías",btn)

func _on_selectionWait_timeout():
	handle_selection = false
	visible = false
	$mensaje.visible = false
	get_tree().get_root().get_node("trivia_main").roundFinished()
