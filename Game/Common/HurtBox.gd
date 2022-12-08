extends Area2D

#const HittEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false  setget set_invincible

onready var timer = $Timer

signal invinciblility_started
signal invinciblility_ended

func set_invincible(value):
	invincible = value
	if invincible ==true:
		emit_signal("invinciblility_started")
	else:
		emit_signal("invinciblility_ended")

func start_invincibility(duration):
	self.invincible=true
	timer.start(duration)

#func create_hit_effect():
#	var effect = HittEffect.instance()
#	var main = get_tree().current_scene
#	main.add_child(effect)
#	effect.global_position=global_position


func _on_Timer_timeout():
	self.invincible = false #we have to call self because setter will be activated when you call self


func _on_HurtBox_invinciblility_started():
	shut_the_hurt_box()

func shut_the_hurt_box():
	set_deferred("monitoring", false)

func _on_HurtBox_invinciblility_ended():
	turn_the_hurt_box()

func turn_the_hurt_box():
	monitoring = true
