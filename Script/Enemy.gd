extends KinematicBody2D

var id : int = 2
export (int, 1, 4, 1) var enemy_type = 1
var speed = 20
onready var timer = get_node("Timer")
onready var timer2 = get_node("Timer2")
var dir_rand =  null
var track_player : bool = false
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
	match enemy_type:
		1:
			which_enemy = flying_eye.instance()
			add_child(which_enemy)
		2:
			which_enemy = goblin.instance()
			add_child(which_enemy)
		3:
			which_enemy = mushroon.instance()
			add_child(which_enemy)
		4:
			which_enemy = skeleton.instance()
			add_child(which_enemy)
	which_enemy.connect("animation_finished", self, "_animation_finished")
	which_enemy.play("move")
	move_dir = Vector2((Vector2(rand_range(-300,300),rand_range(-300,300))-position).normalized())
	timer.start(rand_range(2.5, 3.5))
	
func _physics_process(delta):
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
	if health <= 0:
		which_enemy.play("death")
	else:
		which_enemy.play("hit")

func _animation_finished(anim):
	print(anim)
	if anim == "death":
		get_parent().remove_child(self)
	elif anim != "move":
		which_enemy.play("move")
