extends KinematicBody2D

export var MAX_SPEED = 100
export var ACCELERATION = 10
export var FRICTION = 25
export var ROLL_SPEED = 125

enum {
	MOVE,
	ROLL,
	ATTACK
}

var velosity = Vector2.ZERO
var state = MOVE
var roll_vector = Vector2.DOWN

onready var animationTree = $AnimationTree
onready var animationPlayer = $AnimationPlayer
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox

func _physics_process(delta):
# use if you want to get access to the players possition
#func _physics_process(delta): 
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
		

func _ready():
	animationTree.active = true;
	swordHitbox.knockback_vector = roll_vector

func roll_state(_delta):
	velosity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()
	
func attack_state(_delta):
	velosity = Vector2.ZERO
	animationState.travel("Attack")
	

func finish_attack_annimation():
	state = MOVE
	
func roll_animation_finished():
	state = MOVE

func move():
	velosity = move_and_slide(velosity)
	

func move_state(_delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		swordHitbox.knockback_vector = input_vector
		set_players_animation_when_on_the_move(input_vector)
		velosity = input_vector * MAX_SPEED
		velosity = velosity.clamped(MAX_SPEED)
	else:
		set_players_animation_when_idle(input_vector)
		velosity = velosity.move_toward(Vector2.ZERO, FRICTION)
	
	move()
	
	if(Input.is_action_just_pressed("attack")):
		state = ATTACK
	
	if(Input.is_action_just_pressed("roll")):
		state = ROLL
	
	
func set_players_animation_when_on_the_move(input_vector):
	#the first parameter string is giving us access to the blend positions the path is
	#taken from the Scene/AnimationTree/Parameters/Idle_or_Run if you hover over Blend Position in the UI you see this string
	roll_vector = input_vector

	animationTree.set("parameters/Idle/blend_position", input_vector)
	animationTree.set("parameters/Run/blend_position", input_vector)
	animationTree.set("parameters/Attack/blend_position", input_vector)
	animationTree.set("parameters/Roll/blend_position", input_vector)
	animationState.travel("Run")
		
func set_players_animation_when_idle(_input_vector):
	animationState.travel("Idle")
	
	
