extends KinematicBody2D

var id : int = 1
#Please add this veriable "id" in every PhysicsBody2D or Area2D object
#and assign an unnique value to it.
#Currently id for Player = 1, Enemy = 2, SWORD = 3, BarricadeBody = 4


export var speed = 1000
var motion = Vector2()

var moving = false
onready var animPlayer = get_node("AnimationPlayer")
var movement
var speedMultiplier = 8

var is_collided = false
var dialKeyCheck = false

var IDLE = null
export (int) var timer = 0.2
onready var Cam = $Camera2D

var swinging : bool = false

func _ready():
	IDLE = "idle_down"
	$SWORD.set_deferred("monitoring", false)
	set_physics_process(true)
	set_process(true)
	visible = true
	
	
func _physics_process(delta):
#	GetCollisions()
	CheckingSoundingEffect()
	
func _process(delta):
	ApplyMovement(delta)
	if Input.is_action_just_pressed("ui_accept"):
		swinging = true
		$SWORD.set_deferred("monitoring", true)
		Attack()

func ApplyMovement(deltaTime):
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")	
	var DOWN = Input.is_action_pressed("ui_down")
	
	var dialoque = Input.is_action_pressed("ui_dial")
		
	if LEFT:
		motion = Vector2.LEFT * speed
		moving = true
		IDLE = "idle_left"
		CheckMovementLoop()
		
	elif RIGHT:
		motion = Vector2.RIGHT * speed
		moving = true
		IDLE = "idle_right"
		CheckMovementLoop()
		
	elif UP:
		motion = Vector2.UP * speed
		moving = true
		IDLE = "idle_up"
		CheckMovementLoop()
		
	elif DOWN:
		motion = Vector2.DOWN * speed
		moving = true
		IDLE = "idle_down"
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
	if moving:
		if !sound.is_playing():
			sound.play()
	else:
		sound.stop()
	
func CheckMovementLoop():
	if moving:
		if !motion.is_normalized():
			match motion.normalized():
				Vector2.LEFT:
					movement = "walk_left"
				Vector2.RIGHT:
					movement = "walk_right"
				Vector2.UP:
					movement = "walk_up"
				Vector2.DOWN:
					movement = "walk_down"
			$AnimatedSprite.play(movement)
			if !$SwordAnim.is_playing():
				$SwordAnim.play(movement)
			
	else:
		motion.x = 0
		motion.y = 0
		match movement:
			"walk_left":
				IDLE = "idle_left"
				
			"walk_right":
				IDLE = "idle_right"
			"walk_up":
				IDLE = "idle_up"
			"walk_down":
				IDLE = "idle_down"
		$AnimatedSprite.play(IDLE)
		if !$SwordAnim.is_playing():
			$SwordAnim.play(IDLE)
		
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
	match IDLE:
		"idle_right":
			$SwordAnim.play("swing_right")
		"idle_left":
			$SwordAnim.play("swing_left")
		"idle_up":
			$SwordAnim.play("swing_up")
		"idle_down":
			$SwordAnim.play("swing_down")


func _on_SwordAnim_animation_finished(anim_name):
	if anim_name == "swing_right" or anim_name == "swing_left" or anim_name == "swing_up" or anim_name == "swing_down":
		swinging = false
		$SWORD.set_deferred("monitoring", false)


func _on_SWORD_body_entered(body):
	if !swinging:
		return
	if body.id == 2 :
		swinging = false
		body._take_hit()
