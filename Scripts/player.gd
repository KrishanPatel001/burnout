extends CharacterBody2D

@export var moveSpeed : float = 100
@export var acceleration : float = 50
@export var braking : float = 20
@export var gravity : float = 500
@export var jumpForce : float = 200

var moveInput : float

@onready var sprite : Sprite2D = $Sprite

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	moveInput = Input.get_axis("moveLeft", "moveRight")
	
	if moveInput != 0:
		velocity.x = lerp(velocity.x, moveInput * moveSpeed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, braking * delta)
		
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -jumpForce
		
	move_and_slide()
