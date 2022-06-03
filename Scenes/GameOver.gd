extends Control


func _won(val:bool):
	if val:
		$Won.visible = true
	else:
		$Lost.visible = true
		



func _on_TextureButton_pressed():
	get_parent()._reload()
