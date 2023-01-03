extends HBoxContainer

signal btnPressed(word,button,selected)
var selected = false


func _on_Button_button_down():
	var word = get_node("MarginContainer/Label").get_text()
	var button = get_node("MarginContainer")
	emit_signal("btnPressed",word,button,selected)
