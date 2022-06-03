extends AnimatedSprite

var is_dead : bool = false

func _ready():
	play("move")

func _on_EnemySprite_animation_finished():
	if !is_dead:
		play("move")
	else:
		get_parent()._death_anim_finished()

