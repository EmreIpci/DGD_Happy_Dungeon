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
onready var timer3 = get_node("Timer3")
var dir_rand =  null
var track_player : bool = false
var getting_hit : bool = false
var attack : bool = true
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
	_attack()
	if track_player:
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
	health -= 1
	getting_hit = true
	if health <= 0:
		which_enemy.is_dead = true
		which_enemy.play("death")
	else:
		which_enemy.play("hit")
		timer2.start(0.5)

func _death_anim_finished():
	get_parent().get_parent()._enemy_died()
	queue_free()

func _attack():
	if getting_hit or !attack:
		return
	for i in range(get_slide_count()-1):
		if get_slide_collision(i).collider.id == 1:
			which_enemy.play("attack")
			attack = false
			timer3.start(1.0)

func _on_Timer2_timeout():
	getting_hit = false

func _on_Timer3_timeout():
	attack = true
	for i in range(get_slide_count()-1):
		if get_slide_collision(i).collider.id == 1:
			if !is_boss:
				get_node("/root/World/Player")._lose_health(enemy_type)
			else:
				get_node("/root/World/Player")._lose_health(8)
