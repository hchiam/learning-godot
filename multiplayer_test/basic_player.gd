extends CharacterBody2D
 
func _enter_tree():
	set_multiplayer_authority(name.to_int())
 
func _physics_process(delta):
	if is_multiplayer_authority(): # can control this player
		velocity = Input.get_vector("ui_left","ui_right","ui_up","ui_down") * 400
	move_and_slide()
