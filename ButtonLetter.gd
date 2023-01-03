extends TextureButton

signal btnPressed(letter,button)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	var letter = get_parent().get_node("Label").get_text()
	var button = get_parent()
	emit_signal("btnPressed",letter,button)
	#get_parent().queue_free()
