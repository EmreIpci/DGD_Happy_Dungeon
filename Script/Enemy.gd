extends KinematicBody2D

export (int) var speed = 20
var motion = Vector2()
var direction = ""
var dir_rand =  null 
export (int) var timer = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Attack")
	var dir_rand = rand_range(0, 3)
	setDirection(int(dir_rand))
	
	
func _physics_process(delta):
	
	movement_loop()
	
	pass
	
func setDirection(random_value):
	match random_value:
		0:
			direction = "left"
		1:	
			direction= "right"
		2:
			direction= "up"
		3:
			direction= "down"
	pass

func movement_loop():
	match direction:
		"left":
			move(Vector2.LEFT)
			randomMovement()
		"right":
			move(Vector2.RIGHT)
			randomMovement()
		"up":
			move(Vector2.UP)
			randomMovement()
		"down":
			move(Vector2.DOWN)
			randomMovement()
			
func move(dir):
	if dir == Vector2.LEFT:
		motion = Vector2.LEFT * speed
		move_and_slide(motion)
	elif dir == Vector2.RIGHT:
		motion = Vector2.RIGHT * speed
		move_and_slide(motion)
	elif dir == Vector2.DOWN:
		motion = Vector2.DOWN * speed
		move_and_slide(motion)
	elif dir == Vector2.UP:
		motion = Vector2.UP * speed
		move_and_slide(motion)
		
func randomMovement():
	yield(get_tree().create_timer(timer),"timeout")
	var dir_rand = rand_range(0, 3)
	setDirection(int(dir_rand))
	
