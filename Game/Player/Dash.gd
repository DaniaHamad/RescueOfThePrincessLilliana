extends Node2D

export var DASH_DELAY = 0.5
export var DASH_COLOR = Vector3(1,1,1)
#export var DASH_COLOR = Vector3(0.65882,0.29412,0.64706)

onready var duration_timer = $DurationTimer
onready var ghost_timer = $GhostTimer

signal dash_invinciblility_started
signal dash_invinciblility_ended

var ghost_scene = preload("res://Game/Player/DashGhost.tscn")
var can_dash = true
var sprite



func start_dash(sprite, duration):
	duration_timer.wait_time = duration
	duration_timer.start()
	emit_signal("dash_invinciblility_started")
	self.sprite = sprite
	sprite.material.set_shader_param("mix_weight", 0.7)
	sprite.material.set_shader_param("color", DASH_COLOR)
	sprite.material.set_shader_param("colored", true)
	
	ghost_timer.start()
	instance_ghost()


func instance_ghost():
	var ghost: Sprite = ghost_scene.instance()
	get_parent().get_parent().add_child(ghost)
	ghost.material.set_shader_param("color", DASH_COLOR)
	ghost.global_position = sprite.global_position
	ghost.texture = sprite.texture
	ghost.vframes = sprite.vframes
	ghost.hframes = sprite.hframes
	ghost.frame = sprite.frame
	ghost.flip_h = sprite.flip_h
	
	
func is_dashing():
	return !duration_timer.is_stopped()


func end_dash():
	emit_signal("dash_invinciblility_ended")
	sprite.material.set_shader_param("colored", false)
	ghost_timer.stop()
	
	can_dash = false
	yield(get_tree().create_timer(DASH_DELAY), 'timeout')
	can_dash = true



func _on_DurationTimer_timeout() -> void:
	end_dash()


func _on_GhostTimer_timeout() -> void:
	instance_ghost()
