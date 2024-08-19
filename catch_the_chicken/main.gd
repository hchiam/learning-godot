extends Node

@export var chicken_node: PackedScene
var score
var instanceCounter = 0


func new_game():
	get_tree().call_group(&"mobs", &"queue_free")
	score = 0
	$ChickenAnimation.hide()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()
	spawn_chicken()


func spawn_chicken():
	if instanceCounter == 0 and score >= 100:
		$HUD.show_message("You reached the end! Thanks for playing!")
	
	if instanceCounter > 0 or score > 100:
		return
	
	instanceCounter += 1
	
	var chicken = chicken_node.instantiate()
	
	var mob_spawn_location = get_node(^"MobPath/MobSpawnLocation")
	mob_spawn_location.progress = randi()
	
	var direction = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 5, PI / 5)
	chicken.rotation = direction
	
	chicken.know_score(score)
	
	if score < 20:
		var maxSpeed = 5 * 250
		var fasterWithScore = min(maxSpeed, (score / 5) * randf_range(150.0, 250.0));
		var velocity = Vector2(fasterWithScore, 0.0)
		chicken.linear_velocity = velocity.rotated(direction)
		chicken.position = mob_spawn_location.position
	else:
		var viewportSizeVector = get_viewport().size
		var minDistanceFromPlayer = 150
		var chickenSize = chicken.get_chicken_size()
		while true:
			var randomX = randf_range(chickenSize, viewportSizeVector.x - chickenSize)
			var randomY = randf_range(chickenSize, viewportSizeVector.y - chickenSize)
			chicken.position = Vector2(randomX, randomY)
			if chicken.position.distance_to($Player.global_position) >= minDistanceFromPlayer:
				break
		chicken.player = $Player
		chicken.be_smart()
	
	# Godot 3:
	#chicken.connect("caught", Callable(self, "_on_chicken_caught"))
	#chicken.connect("wentOffScreen", Callable(self, "_on_chicken_off_screen"))
	
	# Godot 4:
	chicken.caught.connect(_on_chicken_caught)
	chicken.wentOffScreen.connect(_on_chicken_off_screen)
	
	add_child(chicken)


func _on_chicken_caught():
	score += 1
	$ChickenCaughtSound.play() # because despawning chicken prevents its child sound from playing
	$HUD.update_score(score)
	if score > 10 and $Player.scale.length() < 2:
		$Player.scale *= 1.1
	if instanceCounter == 1:
		instanceCounter = 0
		spawn_chicken()
		if score > 30 and score < 70:
			spawn_chicken()


func _on_chicken_off_screen():
	if instanceCounter == 1:
		instanceCounter = 0
		spawn_chicken()
