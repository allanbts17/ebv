extends CanvasLayer

signal transition_stoped
# Declare member variables here. Examples:
# var a = 2
# var b = "text"




func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("transition_stoped")
