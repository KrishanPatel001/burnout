extends CharacterBody2D

@export var moveSpeed : float = 100
@export var acceleration : float = 50
@export var braking : float = 20
@export var gravity : float = 500
@export var jumpForce : float = 250
@export var health : int = 3

var moveInput : float
var doubleJump : bool = false
var canDoubleJump : bool = false
var slowFall : bool = false
var sonicSpeed : bool = false
var maxHealth : int = 3

@onready var sprite : Sprite2D = $Sprite
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var muzzle : Marker2D = $Muzzle

signal OnUpdateHealth (health : int)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	moveInput = Input.get_axis("moveLeft", "moveRight")
	if sonicSpeed:
		moveSpeed = 200
	if slowFall:
		gravity = 300
	if moveInput != 0:
		velocity.x = lerp(velocity.x, moveInput * moveSpeed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, braking * delta)
		
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -jumpForce
		canDoubleJump = true
	if doubleJump and Input.is_action_just_pressed("jump") and !is_on_floor() and canDoubleJump:
		velocity.y = -jumpForce
		canDoubleJump = false

		
	move_and_slide()
	
func _process(delta):
	sprite.flip_h = velocity.x < 0
	if global_position.y > 200:
		restart()
	_manage_animation()
	
func _manage_animation():
	if moveInput != 0:
		anim.play("move")
	else:
		anim.play("idle")
		
func restart():
	health = maxHealth
	global_position.x = 0
	global_position.y = 0

func takeDamage(amount : int):
	health -= amount
	OnUpdateHealth.emit(health)
	if health <= 0:
		health = maxHealth
		restart()
