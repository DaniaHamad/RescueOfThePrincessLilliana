extends KinematicBody2D

onready var hurtbox = $HurtBox
onready var blink_animation_player = $BlinkAnimationPlayer

func _on_HurtBox_area_entered(area):
	hurtbox.start_invincibility(0.6)

func _on_HurtBox_invinciblility_started():
	blink_animation_player.play("Blink")

func _on_HurtBox_invinciblility_ended():
	blink_animation_player.play("Stop")

