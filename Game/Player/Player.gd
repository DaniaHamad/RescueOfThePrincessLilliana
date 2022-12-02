extends KinematicBody2D

export var  ACCELERATION= 1140
export var  MOVE_SPEED = 300
export var  FRICTION = 1140
export var DASH_SPEED = 900
export var DASH_DURATION = 0.2

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
		velocity=velocity.move_toward(Vector2.ZERO,ACCELERATION*delta)

	move()
	

	if Input.is_action_just_pressed("attack"):
		animation_state.travel("Attack")
		state=ATTACK
	
	if Input.is_action_just_pressed("dash")&&dash.can_dash &&!dash.is_dashing():
		state=DASH

func attack_state():
	velocity=Vector2.ZERO

func dash_state():
	dash.start_dash(DASH_DURATION)
	velocity = dash_vector * DASH_SPEED
	state=MOVE

func move():
	velocity = move_and_slide(velocity)	
var count=0
func attack_animation_finished():
	count+=1
	print("function called "+str(count))
	state=MOVE
