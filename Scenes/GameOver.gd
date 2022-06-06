extends Control


func _won(val:bool):	#Defining whether the player won or game over.
	if val:
		$Won.visible = true
	else:
		$Lost.visible = true
		



func _on_TextureButton_pressed():	#Play Again.
	get_parent()._reload()
