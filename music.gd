extends Node2D


var allow_music = true
var allow_sfx = true
var song_position = 0.0

onready var musicPlayer = $musicPlayer
onready var sfxPlayer = $sfxPlayer
var librePath = "res://recursos/music/libre.ogg"
var generalSongPath = "res://recursos/music/escalando.ogg"

var button = load("res://recursos/sfx/button.wav")
var defeat = load("res://recursos/sfx/fail_trumpet.wav")
var victory = load("res://recursos/sfx/victory.wav")
var good = load("res://recursos/sfx/good.wav")
var wrong = load("res://recursos/sfx/wrong.wav")
var topMountain = load("res://recursos/sfx/yay.wav")
var saludo = load("res://recursos/sfx/saludoPipe.wav")

func _ready():
	setGeneralSong()

func setGeneralSong():
	var file = load(generalSongPath)
	#print("loop: ",file.loop)
	musicPlayer.stream = file

func setTriviaSong():
	var file = load(librePath)
	musicPlayer.stream = file
	
func play():
	if allow_music:
		musicPlayer.play()
		print("playing")
	
func stop():
	if musicPlayer.is_playing():
		musicPlayer.stop()
	
func pause():
	if musicPlayer.is_playing():
		song_position = musicPlayer.get_playback_position()
		musicPlayer.stop()
	
func resume():
	musicPlayer.play(song_position)

func playSaludo():
	# not sfxPlayer.is_playing() and
	if allow_sfx:
		sfxPlayer.stream = saludo
		sfxPlayer.play()

func playButton():
	# not sfxPlayer.is_playing() and
	if allow_sfx:
		sfxPlayer.stream = button
		sfxPlayer.play()
		
func playDefeat():
	#not sfxPlayer.is_playing() and 
	if allow_sfx:
		sfxPlayer.stream = defeat
		sfxPlayer.play()
		
func playVictory():
	#not sfxPlayer.is_playing() and 
	if allow_sfx:
		sfxPlayer.stream = victory
		sfxPlayer.play()
		
func playTop():
	#not sfxPlayer.is_playing() and 
	if allow_sfx:
		sfxPlayer.stream = topMountain
		sfxPlayer.play()
		
func playGood():
	#not sfxPlayer.is_playing() and
	if allow_sfx:
		sfxPlayer.stream = good
		sfxPlayer.play()
		
func playWrong():
	#not sfxPlayer.is_playing() and
	if  allow_sfx:
		sfxPlayer.stream = wrong
		sfxPlayer.play()
		
func update():
	allow_music = Global.sav_data["setting"]["music"]
	allow_sfx = Global.sav_data["setting"]["sfx"]
	print("Music update: ",allow_music)
