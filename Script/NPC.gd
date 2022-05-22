extends KinematicBody2D

onready var player = null
var speed = 100
var motion = Vector2()
var distacneToAttack = 200

func _ready():
	player = get_parent().get_parent().get_node("Player")
	
func stay():
	player = null
	
	
func follow(deltaTime):
	#distance = start - end um den Abstand zu ermitteln
	var MoveVector = (player.position - position)
	var Velocity = speed * deltaTime
	motion = MoveVector * Velocity
	
	
	if position.distance_to(player.position) <= distacneToAttack:
		look_at(player.global_position)
		move_and_slide(motion)
		
		
func Talk():
	pass
	
func _process(delta):
	follow(delta)
