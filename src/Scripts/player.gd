extends CharacterBody2D

signal start_chatting
signal stop_chatting

@onready var _animated_sprite = $AnimatedSprite2D

const SPEED = 200.0
const JUMP_VELOCITY = -375.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	$Sprite2D.hide()
	$AnimatedSprite2D.show()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
		

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.x > 0:
			$AnimatedSprite2D.flip_h = true
			$Sprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
			$Sprite2D.flip_h = false
		_animated_sprite.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		_animated_sprite.play("stand")
		if Input.is_action_pressed("ui_down") and is_on_floor():
			$AnimatedSprite2D.hide()
			$Sprite2D.show()
	
	
		
	if not is_on_floor():
		_animated_sprite.play("jump")

	move_and_slide()

func _on_npc_area_entered(area):
	start_chatting.emit(area.to_string())

func _on_npc_area_exited(area):
	stop_chatting.emit()
