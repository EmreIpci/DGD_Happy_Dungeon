extends KinematicBody2D

export var speed = 1000
var motion = Vector2()
var moving = false
onready var animPlayer = get_node("AnimationPlayer")
var movement
var speedMultiplier = 8


func _ready():
	set_physics_process(true)
	
	#var button = Button.new()
	#button.text = "Click me"
	#button.connect("pressed", self, "_button_pressed")
	#add_child(button)

	
	#if $AudioStreamPlayer2D.playing == false:
	#	$AudioStreamPlayer2D.play()
	#pass
	
#func _button_pressed():
	#print("Hello world!")
	
func _physics_process(delta):
	ApplyMovement(delta)
	
	

func ApplyMovement(deltaTime):
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")	
	var DOWN = Input.is_action_pressed("ui_down")
	
	var dialoque = Input.is_action_pressed("ui_dial")
		
	if LEFT:
		motion = Vector2.LEFT * speed
		moving = true
		CheckMovementLoop()
		
	elif RIGHT:
		motion = Vector2.RIGHT * speed
		moving = true
		CheckMovementLoop()
		
	elif UP:
		motion = Vector2.UP * speed
		moving = true
		CheckMovementLoop()
		
	elif DOWN:
		motion = Vector2.DOWN * speed
		moving = true
		CheckMovementLoop()
		
	#Dialog während des Spiels
	elif dialoque:
		var dialoque_node = get_parent().get_node("Dialoque/CanvasLayer/dialoque")
		dialoque_node.show_text("Helloworld","Lady")
	#Check ob bewegt wird	
	elif !LEFT or !RIGHT or  !UP or !DOWN:
		moving = false
		CheckMovementLoop()

	# Motion Calculation 
	move_and_slide(motion.normalized() * speed * speedMultiplier * deltaTime)
	
	
	
func CheckMovementLoop():
	if moving:
		if !motion.is_normalized():
			match motion.normalized():
				Vector2.LEFT:
					movement = "walk_left"
					animPlayer.play(movement, -speedMultiplier)
				Vector2.RIGHT:
					movement = "walk_right"
					animPlayer.play(movement, -speedMultiplier)
				Vector2.UP:
					movement = "walk_up"
					animPlayer.play(movement, -speedMultiplier)
				Vector2.DOWN:
					movement = "walk_down"
					animPlayer.play(movement, -speedMultiplier)
			
	elif !moving:
		motion.x = 0
		motion.y = 0
		match movement:
			"walk_left":
				animPlayer.play("idle_left")
			"walk_right":
				animPlayer.play("idle_right")
			"walk_up":
				animPlayer.play("idle_up")
			"walk_down":
				animPlayer.play("idle_down")
