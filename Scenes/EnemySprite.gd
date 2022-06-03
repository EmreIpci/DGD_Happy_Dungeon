extends AnimatedSprite

var is_death : bool = false

func _ready():
	play("move")

func _on_EnemySprite_animation_finished():
	if !is_death:
		play("move")
	else:
		get_parent()._death_anim_finished()
