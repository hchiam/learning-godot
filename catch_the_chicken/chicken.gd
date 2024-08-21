extends RigidBody2D

signal caught
signal wentOffScreen

var player: Area2D
var score = 0
var isSmartChicken = false
var goingRandomDirection = false
var lastRandomDirection = randf_range(0,  2.0 * PI)

func _ready():
	if rotation < - PI /2 or rotation > PI /2:
		$AnimatedSprite2D.flip_v = true
	
	$AnimatedSprite2D.play()


func _on_VisibilityNotifier2D_screen_exited():
	wentOffScreen.emit()
	queue_free()


func _on_area_2d_area_entered(area):
	$AnimatedSprite2D.hide()
		
	# disable while accounting for physics:
	$Area2D/CollisionShape2D.set_deferred('disabled', true)
	
	#linear_velocity = Vector2.ZERO
	
	caught.emit()
	
	if isSmartChicken and score < 70:
		$Area2D/ChickenCaughtSound.play() # so that each chicken makes a sound
		## this delay could cause double-spawning of chickens if they go off-screen while caught:
		var timeForSoundEffect = 1.0
		await get_tree().create_timer(timeForSoundEffect).timeout
	queue_free()


func know_score(playerScore):
	score = playerScore


func be_smart():
	isSmartChicken = true


func _on_timer_timeout():
	goingRandomDirection = !goingRandomDirection
	lastRandomDirection = randf_range(0,  2.0 * PI)


func _physics_process(delta):
	if isSmartChicken:
		look_at(player.global_position)
		rotation += PI # face away
		
		var baseVelocity = Vector2(randf_range(150, 250 + score/5), 0)
		
		if goingRandomDirection:
			rotation = lastRandomDirection
			baseVelocity = Vector2(randf_range(75, 150), 0)
		
		linear_velocity = baseVelocity.rotated(rotation)
	else: # if not smart chicken:
		if score < 10:
			avoid_edges(delta)


func avoid_edges(delta):
	var viewport_size = get_viewport().size
	var screen_margin = -1 # so 0 is fine, to allow animations at start
	
	if (position.x < screen_margin 
	or position.x > viewport_size.x - screen_margin 
	or position.y < screen_margin 
	or position.y > viewport_size.y - screen_margin):
		rotation += PI # turn 180 degrees
		linear_velocity = linear_velocity.rotated(rotation)
	
	# flip the sprite vertically if necessary:
	if rotation < -PI / 2 or rotation > PI / 2:
		$AnimatedSprite2D.flip_v = true


func get_chicken_size():
	var collision_shape = $Area2D/CollisionShape2D.shape
	if collision_shape is CapsuleShape2D:
		return collision_shape.radius + collision_shape.height / 2
	else:
		return 20 # fallback
