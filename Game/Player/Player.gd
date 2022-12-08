extends KinematicBody2D

export var  ACCELERATION= 1340
export var  MOVE_SPEED = 500
export var  FRICTION = 1340
export var DASH_SPEED = 1350
export var DASH_DURATION = 0.4

enum{
	MOVE,
	ATTACK,
	DASH
}

var state = MOVE
var velocity=Vector2.ZERO
var dash_vector = Vector2.DOWN

onready var animation_player =$AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var dash = $Dash
onready var sprite = $Sprite
onready var blink_animation_player = $BlinkAnimationPlayer
onready var hurtbox = $HurtBox

func _ready():
	animation_tree.active =true


func _physics_process(delta):
	match state:
		MOVE: 
			move_state(delta)
		ATTACK:
			attack_state()
		DASH:
			dash_state()

func move_state(delta):
	var input_vector=Vector2.ZERO
	input_vector.x=Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	input_vector.y=Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	input_vector= input_vector.normalized()
	
	if input_vector!=Vector2.ZERO:
		dash_vector = input_vector
		animation_tree.set("parameters/Idle/blend_position",input_vector)
		animation_tree.set("parameters/Run/blend_position",input_vector)
		animation_tree.set("parameters/Attack/blend_position",input_vector)
		animation_state.travel("Run")
		velocity=velocity.move_toward(input_vector*MOVE_SPEED,ACCELERATION*delta)
	else:
		animation_state.travel("Idle")
		velocity=Vector2.ZERO
	
	move()
	

	if Input.is_action_just_pressed("attack"):
		animation_state.travel("Attack")
		state=ATTACK
	
	if Input.is_action_just_pressed("dash")&&dash.can_dash &&!dash.is_dashing()&&input_vector!=Vector2.ZERO:
		dash.start_dash(sprite,DASH_DURATION)
		state=DASH

func attack_state():
	print("attack started")
	velocity=Vector2.ZERO

func dash_state():
	velocity = dash_vector * DASH_SPEED
	move()


func move():
	velocity = move_and_slide(velocity)	

func attack_animation_finished():
	state=MOVE


func _on_HurtBox_area_entered(area):
	hurtbox.start_invincibility(0.6)

func _on_HurtBox_invinciblility_started():
	blink_animation_player.play("Blink")

func _on_HurtBox_invinciblility_ended():
	blink_animation_player.play("Stop")


func _on_Dash_dash_invinciblility_started():
	hurtbox.shut_the_hurt_box()


func _on_Dash_dash_invinciblility_ended():
	hurtbox.turn_the_hurt_box()
	velocity = velocity *0.8
	state=MOVE
	print("dash ended")
