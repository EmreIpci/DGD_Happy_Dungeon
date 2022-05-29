extends KinematicBody2D

export var speed = 1000
var motion = Vector2()

var moving = false
onready var animPlayer = get_node("AnimationPlayer")
var movement
var speedMultiplier = 8

var is_collided = false
var dialKeyCheck = false

var IDLE = null

var sword_iteself = preload("res://Attacks/SWORD.tscn")
var sword_item = null
export (int) var timer = 0.2

onready var Cam = $Camera2D


func _ready():
	set_physics_process(true)
	set_process(true)

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
	
func _process(delta):
	Attack()
	GetCollisions()
	CheckingSoundingEffect()

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

#Going soundeffects
func CheckingSoundingEffect():
	
	var sound = $AudioStreamPlayer2D
	
#	var LEFT = Input.is_action_just_pressed("ui_left")
#	var RIGHT = Input.is_action_just_pressed("ui_right")
#	var UP = Input.is_action_just_pressed("ui_up")
#	var DOWN = Input.is_action_just_pressed("ui_down")
#
#	var Direction = [LEFT,RIGHT,UP,DOWN]
#
#	var LEFT_RELEASE = Input.is_action_just_released("ui_left")
#	var RIGHT_RELEASE = Input.is_action_just_released("ui_right")
#	var UP_RELEASE = Input.is_action_just_released("ui_up")
#	var DOWN_RELEASE = Input.is_action_just_released("ui_down")
#
#	var Direction_Release = [LEFT_RELEASE,RIGHT_RELEASE,UP_RELEASE,DOWN_RELEASE]
		
	
	if moving:
		if !sound.is_playing():
			sound.play()
	else:
		sound.stop()
	
#	if LEFT:
#		sound.play()
#	if RIGHT:
#		sound.play()
#	if DOWN:
#		sound.play()
#	if UP:
#		sound.play()
#
#	if LEFT_RELEASE:
#		sound.stop()
#	if RIGHT_RELEASE:
#		sound.stop()
#	if DOWN_RELEASE:
#		sound.stop()
#	if UP_RELEASE:
#		sound.stop()
	
	pass	
	
func CheckMovementLoop():
	if moving:
		if !motion.is_normalized():
			match motion.normalized():
				Vector2.LEFT:
					movement = "walk_left"
					$AnimatedSprite.play(movement)
					#animPlayer.play(movement, -speedMultiplier)
				Vector2.RIGHT:
					movement = "walk_right"
					$AnimatedSprite.play(movement)
					#animPlayer.play(movement, -speedMultiplier)
				Vector2.UP:
					movement = "walk_up"
					$AnimatedSprite.play(movement)
					#animPlayer.play(movement, -speedMultiplier)
				Vector2.DOWN:
					movement = "walk_down"
					$AnimatedSprite.play(movement)
					#animPlayer.play(movement, -speedMultiplier)
			
	elif !moving:
		motion.x = 0
		motion.y = 0
		match movement:
			"walk_left":
				IDLE = "idle_left"
				$AnimatedSprite.play(IDLE)
#				animPlayer.stop()
#				animPlayer.play(IDLE)
			"walk_right":
				IDLE = "idle_right"
				$AnimatedSprite.play(IDLE)
#				animPlayer.stop()
#				animPlayer.play(IDLE)
			"walk_up":
				IDLE = "idle_up"
				$AnimatedSprite.play(IDLE)
#				animPlayer.stop()
#				animPlayer.play(IDLE)
			"walk_down":
				IDLE = "idle_down"
				$AnimatedSprite.play(IDLE)
#				animPlayer.stop()
#				animPlayer.play(IDLE)
				
func GetCollisions():
	for i in range(get_slide_count()):
		var enemy = get_slide_collision(i).collider.has_method("is_enemy")
		
		if enemy == true:
			queue_free()
			print("Goto End Screen")
			
func DialCheck():
	dialKeyCheck = Input.is_action_pressed("ui_dial")
	return dialKeyCheck
	
func Attack():
	if Input.is_action_just_pressed("ui_accept"):
		match IDLE:
			"idle_right":
				#Instance a sword with left axis
				var sword_item = sword_iteself.instance()
				sword_item.position=get_node("Sprite").global_position
				
				#play Animation
				sword_item.get_node("AnimationPlayer").play("RIGHT")
				
				var g = get_parent().get_children()
				if g.has(sword_item):
					return
				get_parent().add_child(sword_item)
				
				#Start a timer
				yield(get_tree().create_timer(timer),"timeout")
				#if the timer ends destroy sword
				sword_item.queue_free()
				
			"idle_left":
				#Instance a sword with left axis
				var sword_item = sword_iteself.instance()
				sword_item.position=get_node("Sprite").global_position
				
				#play Animation
				sword_item.get_node("AnimationPlayer").play("LEFT")
				
				var g = get_parent().get_children()
				if g.has(sword_item):
					return
				get_parent().add_child(sword_item)
				
				#Start a timer
				yield(get_tree().create_timer(timer),"timeout")
				#if the timer ends destroy sword
				sword_item.queue_free()
				
			"idle_up":
				#Instance a sword with left axis
				var sword_item = sword_iteself.instance()
				sword_item.position=get_node("Sprite").global_position
				
				#play Animation
				sword_item.get_node("AnimationPlayer").play("UP")
				
				var g = get_parent().get_children()
				if g.has(sword_item):
					return
				get_parent().add_child(sword_item)
				
				#Start a timer
				yield(get_tree().create_timer(timer),"timeout")
				#if the timer ends destroy sword
				sword_item.queue_free()
				
			"idle_down":
				#Instance a sword with left axis
				var sword_item = sword_iteself.instance()
				sword_item.position=get_node("Sprite").global_position
				
				#play Animation
				sword_item.get_node("AnimationPlayer").play("DOWN")
				
				var g = get_parent().get_children()
				if g.has(sword_item):
					return
				get_parent().add_child(sword_item)
				
				#Start a timer
				yield(get_tree().create_timer(timer),"timeout")
				#if the timer ends destroy sword
				sword_item.queue_free()
