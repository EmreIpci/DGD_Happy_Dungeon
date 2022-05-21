extends KinematicBody2D

export (int) var speed = 100
var motion = Vector2()
var direction = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Attack")
	
	
func _physics_process(delta):
	var dir_rand = rand_range(0, 3)
	setDirection(dir_rand)
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
			motion=Vector2.LEFT * speed
		"right":
			motion=Vector2.RIGHT * speed
		"up":
			motion=Vector2.UP * speed
		"down":
			motion=Vector2.DOWN * speed
			
	move_and_slide(motion)
