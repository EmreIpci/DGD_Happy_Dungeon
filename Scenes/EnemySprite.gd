extends AnimatedSprite

var is_dead : bool = false

func _ready():	#keep the enemy always moving.
	play("move")

func _on_EnemySprite_animation_finished():
	if !is_dead:	#death animation is played only once, after that call the enemy to die.
		play("move")
	else:
		get_parent()._death_anim_finished()

