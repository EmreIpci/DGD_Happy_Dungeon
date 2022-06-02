extends Node2D

export (int) var number_of_enemies = 5
var enemy = preload("res://Enemy/Enemy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	randomize()
	var screen_size = get_viewport().get_visible_rect().size
	$barricades/barricadeBody/CollisionPolygon2D.polygon = $barricades/barricadeBody/Path2D.curve.tessellate()
	
#	for i in range(1,number_of_enemies):
#
#		var xRange = rand_range(0,screen_size.x)
#		var yRange = rand_range(0,screen_size.y)
#
#		var enemy_instance = enemy.instance()
#
#		enemy_instance.position = Vector2(rand_range(0,screen_size.x),rand_range(0,screen_size.y))
#
#		add_child(enemy_instance)
