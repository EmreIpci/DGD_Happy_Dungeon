extends Node2D

export (int) var number_of_enemies = 5
var enemy = preload("res://Enemy/Enemy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	get_tree().paused = false
	$barricades/barricadeBody/CollisionPolygon2D.polygon = $barricades/barricadeBody/Path2D.curve.tessellate()
	
func _enemy_died():
	if $EnemyPlacer.get_child_count() <= 1:
		$GameOver.set_position($Player.position)
		$GameOver._won(true)
		$GameOver.visible = true

func _reload():
	get_tree().reload_current_scene()





func _on_PauseButton_pressed():
	get_tree().paused = !get_tree().paused
