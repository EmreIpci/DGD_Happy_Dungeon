extends Node2D

export (int) var number_of_enemies = 5
var enemy = preload("res://Enemy/Enemy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var rand = RandomNumberGenerator.new()
	
	
	var screen_size = get_viewport().get_visible_rect().size
	
	for i in range(1,number_of_enemies):
		
		var xRange = rand.randf_range(0,screen_size.x)
		var yRange = rand.randf_range(0,screen_size.y)
		
		var enemy_instance = enemy.instance()
		
		
		var pos = Vector2()
		pos.x = xRange
		pos.y = yRange
		
		enemy_instance.position = pos
		
		add_child(enemy_instance)
		


