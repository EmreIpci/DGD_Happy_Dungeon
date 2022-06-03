extends KinematicBody2D

var id : int = 2
#Please add this veriable "id" in every PhysicsBody2D or Area2D object
#and assign an unnique value to it.
#Currently id for Player = 1, Enemy = 2, SWORD = 3, BarricadeBody = 4


export (int, 1, 4, 1) var enemy_type = 1
export var is_boss : bool = false
var speed = 20
onready var timer = get_node("Timer")
onready var timer2 = get_node("Timer2")
var dir_rand =  null
var track_player : bool = false
var attacking : bool = false
var player
var move_dir : Vector2
var which_enemy
var health : int = 2

var flying_eye = preload("res://Scenes/EnemyFlyingEye.tscn")
var goblin = preload("res://Scenes/EnemyGoblin.tscn")
var mushroon = preload("res://Scenes/EnemyMashroom.tscn")
var skeleton = preload("res://Scenes/EnemySkeleton.tscn")


func _ready():
	randomize()
	health = enemy_type * 2
	match enemy_type:
		1:
			which_enemy = flying_eye.instance()
		2:
			which_enemy = goblin.instance()
		3:
			which_enemy = mushroon.instance()
		4:
			which_enemy = skeleton.instance()
			
	add_child(which_enemy)
	if is_boss:
		health = 20
		scale *= 3
	move_dir = Vector2((Vector2(rand_range(-300,300),rand_range(-300,300))-position).normalized())
	timer.start(rand_range(2.5, 3.5))
	
func _physics_process(delta):
	if track_player:
		if (player.get_global_position().x - get_global_position().x) < 12:
			if !attacking:
				_attack()
			return
		move_dir = (player.position - position).normalized()
		if move_dir.x < 0:
			which_enemy.flip_h = true
		else:
			which_enemy.flip_h = false
		move(move_dir)
		return
	movement_loop()

func movement_loop():
	if move_dir.x < 0:
		which_enemy.flip_h = true
	else:
		which_enemy.flip_h = false
	move(move_dir)

func move(dir):
	move_and_slide(dir * speed)
		

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		$Label.visible = true
		track_player = true
		speed = 50
		player = body

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		$Label.visible = false
		track_player = false
		speed = 20

func _on_Timer_timeout():
	move_dir = Vector2((Vector2(rand_range(-300,300),rand_range(-300,300))-position).normalized())
	timer.start(rand_range(2.5, 3.5))

func _take_hit():
	print("hit")
	health -= 1
	if health <= 0:
		which_enemy.is_death = true
		which_enemy.play("death")
	else:
		which_enemy.play("hit")

func _death_anim_finished():
	queue_free()

func _attack():
	attacking = true
	which_enemy.play("attack")
	timer2.start(1.5)
	

func _on_Timer2_timeout():
	attacking = false
