extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -1000.0
var thrust = Vector2(0, 0)
var torque = 20000
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var distance_travel = 0
var total_distance = 0

func _ready():
	$AnimatedSprite2D.visible = false
	#$Troposphere.modulate = Color(0, 1, 1, 1)

func _process(delta):
	pass
	#if Global.fuel_timer == true:
		#distance_travel += velocity.y*delta

func _physics_process(delta):
	#modulate_atmosphere()
	# Add the gravity.
	if Global.fuel_timer == false:
		$Camera2D/DistanceLabel.text = "Total Distance: " + str(abs(total_distance)).pad_decimals(1) + " KM"
		if not is_on_floor():
			velocity.y += gravity * delta

	# Handle jump.
	if Global.rocket_speed_timer == false:
		if Input.is_action_just_pressed("Launch") and is_on_floor():
			total_distance = 0
			distance_travel = 0
			velocity.y = Global.rocket_velocity
			$FuelTimer.start()
			Global.fuel_timer = true
			$AnimatedSprite2D.visible = true
			$AnimatedSprite2D.play("Booster")
	
	if abs(total_distance) > Global.highest_distance:
		Global.highest_distance = abs(total_distance)
	
	if Global.fuel_timer == true:
		distance_travel += (velocity.y*delta)/600
		
		$Camera2D/FuelTimerLabel.text = str($FuelTimer.get_time_left()).pad_decimals(1)
		$Camera2D/DistanceLabel.text = "Distance traveled: " + str(abs(distance_travel)).pad_decimals(1) + " KM"
		$Camera2D/HighestDistanceLabel.text = "Highest Distance traveled: " + str(Global.highest_distance).pad_decimals(1) + " KM"
		
	if $RayCast2D.is_colliding() and is_on_floor() and velocity.y == 0:
		Global.rocket_is_on_floor = true
		
	move_and_slide()


func _on_fuel_timer_timeout():
	Global.rocket_velocity = 0
	Global.fuel_timer = false
	total_distance = distance_travel
	$AnimatedSprite2D.visible = false
	
func modulate_atmosphere():
	#var tween = get_tree().create_tween()
	if distance_travel > -12.0:
		#tween.tween_property($Troposphere, "modulate", Color(0, 150, 255, 1), 1)
		$Troposphere.modulate = Color(0, 1, 1, 1) # blue shade
	elif distance_travel > -50.0:
		#tween.tween_property($Troposphere, "modulate", Color(0, 136, 201, 1), 1)
		$Troposphere.modulate = Color(0.372549, 0.619608, 0.627451, 1)
	elif distance_travel > -80.0:
		#tween.tween_property($Troposphere, "modulate", Color(0, 55, 120, 1), 1)
		$Troposphere.modulate = Color(0, 0, 0.545098, 1)
	elif distance_travel > -500.0:
		#tween.tween_property($Troposphere, "modulate", Color(0, 31, 85, 1), 1)
		$Troposphere.modulate = Color(0, 0, 0, 1)
