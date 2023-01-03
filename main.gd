extends Node2D

export (PackedScene) var scene
#JSON Data

var path = "user://sav.json"
var first = false
var open = true

var init_data = {
	"setting":{
		"name":"",
		"music":true,
		"sfx":true,
		"first":true
	},
	"progress":{
		"score":0,
		"unlocked":[1,1],
		"per_level_score":{
			"1":{
				"1":0,
				"2":0,
				"3":0,
				"4":0,
				"5":0
			},
			"2":{
				"1":0,
				"2":0,
				"3":0,
				"4":0,
				"5":0
			},
			"3":{
				"1":0,
				"2":0,
				"3":0,
				"4":0,
				"5":0
			},
			"4":{
				"1":0,
				"2":0,
				"3":0,
				"4":0,
				"5":0
			},
			"5":{
				"1":0,
				"2":0,
				"3":0,
				"4":0,
				"5":0
			}
		}
	}
}

#Pages
onready var first_time_page = get_node("firstTime")
onready var next_time_page = get_node("nextTime")
onready var name_setting_page = get_node("nameSetting")
#Components
onready var name_field = get_node("nameSetting/textField")
onready var first_jugar_btn = get_node("firstTime/superiorBtn/jugarBtn")
onready var next_jugar_btn = get_node("nextTime/supBtns/superiorBtn/jugarBtn")
onready var listo_btn = get_node("nameSetting/superiorBtn/ListoBtn")
onready var cambiar_nombre_btn = get_node("nextTime/supBtns/superiorBtn2/cambiarNombreBtn")
onready var return_btn = get_node("nameSetting/return")
onready var music_btn = get_node("nextTime/downBtns/music")
onready var sfx_btn = get_node("nextTime/downBtns/sfx")

# Called when the node enters the scene tree for the first time.
func _ready():
	ifOpen()
	updateSoundBtns()
	principalPageSelect()
	resetSavData()


func ifOpen():
	if Global.open:
		loadSavData()
		updateMusic()
		updateGlobal()
		startMusic()
		setFirst()
		Global.open = false
	
func updateGlobal():
	Global.update()

func updateMusic():
	music.update()
	
func startMusic():
	music.play()
		
func setFirst():
	first = Global.sav_data["setting"]["first"]

func principalPageSelect():
	if first:
		setPage("first")
	else:
		setPage("next")
		
func setNameOnField():
	name_field.set_text(Global.sav_data["setting"]["name"])
	
func setPage(page):
	if page == "first":
		first_time_page.visible = true
		next_time_page.visible = false
		name_setting_page.visible = false
	elif page == "next":
		first_time_page.visible = false
		next_time_page.visible = true
		name_setting_page.visible = false
	else:
		setNameOnField()
		first_time_page.visible = false
		next_time_page.visible = false
		name_setting_page.visible = true

func loadSavData():
	var file = File.new()
	if not file.file_exists(path):
		Global.sav_data = init_data.duplicate(true)
	else:
		var json
		file.open(path, file.READ)
		json = file.get_as_text()
		Global.sav_data = JSON.parse(json).result
	file.close()
	
func setSavData():
	var file = File.new()
	file.open(path, file.WRITE)
	file.store_line(to_json(Global.sav_data))
	file.close()

func resetSavData():
	var file = File.new()
	file.open(path, file.WRITE)
	file.store_line(to_json(init_data))
	file.close()


func _on_music_toggled(button_pressed):
	if Global.open:
		music.playButton()
	if button_pressed:
		Global.sav_data["setting"]["music"] = false
		music.allow_music = false
		music.pause()
	else:
		Global.sav_data["setting"]["music"] = true
		music.allow_music = true
		music.resume()
	setSavData()

func _on_sfx_toggled(button_pressed):
	if Global.open:
		music.playButton()
	if button_pressed:
		Global.sav_data["setting"]["sfx"] = false
		music.allow_sfx = false
	else:
		Global.sav_data["setting"]["sfx"] = true
		music.allow_sfx = true
	setSavData()

func updateSoundBtns():
	music_btn.pressed = not Global.sav_data["setting"]["music"]
	sfx_btn.pressed = not Global.sav_data["setting"]["sfx"]
	

func _on_jugarBtn_button_down():
	var scalar = 0.9
	if first:
		first_jugar_btn.rect_scale = Vector2(scalar,scalar)
	else:
		next_jugar_btn.rect_scale = Vector2(scalar,scalar)

func _on_jugarBtn_button_up():
	music.playButton()
	if first:
		setPage("name")
	else:
		Global.mountain = 1
		get_tree().change_scene_to(scene)


func _on_ListoBtn_button_down():
	var scalar = 0.9
	listo_btn.rect_scale = Vector2(scalar,scalar)

func _on_ListoBtn_button_up():
	music.playButton()
	updateName()
	if first:
		updateFirst()
		get_tree().change_scene_to(scene)
	else:
		setPage("next")

func updateFirst():
	first = false

func updateName():
	var text =  name_field.get_text()
	if not text == "":
		Global.sav_data["setting"]["name"] = name_field.get_text()
		setSavData()
		Global.update()
		Dialogic.set_variable("name",Global.player_name)
		Dialogic.save_definitions()


func _on_cambiarNombreBtn_button_down():
	var scalar = 0.9
	cambiar_nombre_btn.rect_scale = Vector2(scalar,scalar)
	
func _on_cambiarNombreBtn_button_up():
	music.playButton()
	setPage("name")


func _on_return_button_up():
	music.playButton()
	if first:
		setPage("first")
	else:
		setPage("next")

func _on_return_button_down():
	var scalar = 0.96
	return_btn.rect_scale = Vector2(scalar,scalar)
	
