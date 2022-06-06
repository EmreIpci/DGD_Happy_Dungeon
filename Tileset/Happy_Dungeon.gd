extends Node2D

export (int) var number_of_enemies = 5
var enemy = preload("res://Enemy/Enemy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	get_tree().paused = false
	
	#Instead of adding lots of collissionshape2D, we added a path 2d to define the boundaries
	#which is extendable at any time and assign it as the polygon of the collisionPolygon of the Boumdary body.
	$barricades/barricadeBody/CollisionPolygon2D.polygon = $barricades/barricadeBody/Path2D.curve.tessellate()


#Called when an enemy dies, checks how many enemies left, if none shows Winner.
func _enemy_died():
	if $EnemyPlacer.get_child_count() <= 1:
		$GameOver.set_position($Player.position)
		$GameOver._won(true)
		$GameOver.visible = true

#Called when Player pressed "Play Again" from game over scene, restarts the game.
func _reload():
	get_tree().reload_current_scene()





func _on_PauseButton_pressed():
	get_tree().paused = !get_tree().paused
