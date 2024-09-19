extends Node2D

const ROCKET_MAIN_POS := Vector2i(171, 603)
var click_timer_label_value = 10
var fuel_timer_label_value = 10
var minus = -1
#var velocity = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	$RocketBody2D.position = ROCKET_MAIN_POS
	$ClickRocketSpeedTimer.start()
	Global.rocket_speed_timer = true
	Global.fuel_timer = false
	$GroundSprite2D/Ground2D.modulate = Color(0, 0, 0, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.rocket_speed_timer == true and Global.rocket_is_on_floor == true:
		if Input.is_action_just_pressed("Launch"):
			Global.rocket_velocity += -100 + Global.game_count
			
	#if Global.fuel_timer == true:
		#$FuelTimer.start()
		
	label_disp()
	
	if Global.rocket_is_on_floor == true and Global.rocket_velocity == 0:
		Global.rocket_speed_timer = true
		$ClickRocketSpeedTimer.start()
		
		

func label_disp():
	$RocketBody2D/Camera2D/SpeedLabel.text = "SPEED: " + str(abs(Global.rocket_velocity))
	$RocketBody2D/Camera2D/ClickTimerLabel.text = str($ClickRocketSpeedTimer.get_time_left()).pad_decimals(1)
	#if Global.fuel_timer == true:
		#Global.fuel_timer_countdown = $FuelTimer.get_time_left()

func _on_click_rocket_speed_timer_timeout():
	Global.rocket_speed_timer = false
	Global.game_count += -1


func _on_fuel_timer_timeout():
	pass
