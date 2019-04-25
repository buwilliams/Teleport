extends KinematicBody2D

signal player_dead

export (int) var speed = 350
export (int) var gravity = 20000
export (int) var jump = 800

var grounded = false

var max_jump_process_count = 12
var jump_process_count = 0

var double_jump = false
var jumping = false

var velocity = Vector2(0, 0)

var max_player_y = 1500

func get_input():
	var adjusted_gravity = gravity
	
	if Input.is_action_pressed('ui_right'):
		velocity.x += speed
	
	if Input.is_action_pressed('ui_left'):
		velocity.x -= speed
	
	if Input.is_action_pressed('ui_down'):
		velocity.y += speed
		
	if grounded == true:
		double_jump = false
		jump_process_count = 0
		jumping = false
		
	if Input.is_action_just_pressed('ui_up'):
		if grounded == false && double_jump == false:
			double_jump = true
			jump_process_count = 0
			print("double jump")
		elif grounded == true:
			jumping = true
	
	if jumping == true && jump_process_count <= max_jump_process_count:
		velocity.y = -jump
		jump_process_count += 1

func _physics_process(delta):
	velocity = Vector2(0, 0)
		
	# Add gravity
	velocity.y += gravity * delta
	
	get_input()
	
	check_player_position()
	
	move_and_slide(velocity)

func _on_Feet_body_shape_entered(body_id, body, body_shape, area_shape):
	grounded = true
	print("feet entered")
	pass # Replace with function body.

func _on_Feet_body_shape_exited(body_id, body, body_shape, area_shape):
	grounded = false
	print("feet exited")
	pass # Replace with function body.

func check_player_position():
	var pos = get_global_position()
	if pos.y > max_player_y:
		emit_signal("player_dead")
	#print("Position y: ", pos.y)
	pass # Replace with function body.
