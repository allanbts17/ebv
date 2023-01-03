extends Node

var mountain = 1
var trivia_point = 1
var round_number = 1

var open = true

var sav_data
var trivia_data
var first_time = true #regist data in file

var path = "user://sav.json"

var score = 0
var actual_level_score = 0
var max_actual_level_score = 0

var player_name = ""
var end_mountain_dialogs = {
	1:"cimaAbraham",
	2:"cimaMoisesJoven",
	3:"cimaMoisesViejo",
	4:"cimaElias",
	5:"cimaJesus"
}
var dialogos = {
	1:{
		1:"personajeFavorito",
		2:"viboras",
		3:"acantilado",
		4:"felinos",
		5:"desafioPipe2"
	},
	2:{
		1:"personajeFavorito",
		2:"oso",
		3:"hambre",
		4:"casiLlegamos",
		5:"desafioPipe1"
	},
	3:{
		1:"viboras",
		2:"desafioPipe2",
		3:"sed",
		4:"casiLlegamos",
		5:"oso"
	},
	4:{
		1:"felinos",
		2:"viboras",
		3:"hambre",
		4:"descanso",
		5:"desafioPipe2"
	},
	5:{
		1:"felinos",
		2:"sed",
		3:"descanso",
		4:"acantilado",
		5:"desafioPipe2"
	}
}
	
	

func _ready():
	pass

func update():
	player_name = sav_data["setting"]["name"]
	score = sav_data["progress"]["score"]
	print("Update: ",player_name)
	
func setSavData():
	var file = File.new()
	file.open(path, file.WRITE)
	file.store_line(to_json(sav_data))
	file.close()

