# Learning Godot (game engine)

Just one of the things I'm learning. https://github.com/hchiam/learning

https://www.youtube.com/watch?v=QKgTZWbwD1U

https://github.com/godotengine/godot

intro: https://docs.godotengine.org/en/stable/getting_started/introduction/index.html 
- intro, 2D: https://docs.godotengine.org/en/stable/getting_started/first_2d_game/index.html + completed [2D tutorial code](https://github.com/godotengine/godot-demo-projects/tree/master/2d/dodge_the_creeps)
- intro, 3D: https://docs.godotengine.org/en/stable/getting_started/first_3d_game/index.html

best practices: https://docs.godotengine.org/en/stable/tutorials/best_practices/introduction_best_practices.html
- physics: https://docs.godotengine.org/en/stable/tutorials/physics/index.html
- multi-player networking: https://docs.godotengine.org/en/stable/tutorials/networking/index.html
  - example code for player-hosted lobby: https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html#example-lobby-implementation
  - https://github.com/godotengine/godot-demo-projects/tree/master/networking

GDScript: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/index.html#toc-learn-scripting-gdscript
- For syntax notes on things like `&"` and `^"`, Ctrl+F in this page: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
  - `$Player.position` and `$UserInterface/Retry.show()`

animation tips from DevWorm: https://youtu.be/XbDh2GAshBA?feature=shared

some helpful Godot plugins: https://youtu.be/bKNmsae5zXk?feature=shared

## miscellaneous notes

For Ctrl+F convenience to remind myself of things:

- in my mind, there's only really 2 core concepts in godot: nodes and signals:
  - scenes are the same thing as nodes, just isolated so you can run a sub-tree in isolation. everything's nested in trees of nodes. simpler than thinking in MVC (Model-View-Controller).
  - signals enable "notification" callbacks (observer pattern). a node sends out a signal, and you can attach nodes to listen to that signal.
- keyboard shortcuts:
  - option + spacebar = search help documentation
    - (random tip: you can hover over a lot of things in the panels to get more info about them, like even titles/dropdowns/buttons/labels/fields)
  - cmd + b = run from main
  - cmd + r = run current scene
  - cmd + . = stop running
  - **_cmd + shift + A_**
    - = "import" an _instance_ of an other scene as a child node, which packages/hides that other scene's own children from view of the current scene
    - you have to save the original instance for the "imported" instances to update to match
    - you can customize one of those instances, which overrides the original instance's properties
      - you can show an instance's children with: right-click > checkmark Editable Children
    - you can customize one of those instances' PhysicsMaterial (a resource) in the Inspector panel with: down arrow dropdown > **_Make Unique_** > props unlocked!
  - cmd + d = duplicate
  - cmd + c --> cmd + v = create child
- you can mix scripting languages as needed (e.g. use C# only to implement complex algorithms with better performance)
- to add an image as a texture to a Sprite2D: Inspector > Texture > click to show dropdown > Load...
- to add a script to a node: Scene > right-click > Attach Script...
- to connect a signal:
  - through the editor: select a node > Node panel > double-click a signal for that node > select a node that has a script (a receiver method will be auto-named) > Connect
    - the **_listener_**/target node will have the callback written in its script
    - ```gd
      func _on_button_pressed(): # you'll see a "->]" icon on the left side of this func
  	    set_process(not is_processing()) # toggle whether _process(delta) is running
      ```
    - (note: the listener/target node can also be itself, e.g. Area2D `body_entered(body:Node2D)` signal `-->]` `func _on_body_entered(_body)` in the script file of same node)
  - through code (needed when creating nodes inside of a script):
    - ```gd
      func _ready():
        var timer: Timer = get_node('Timer') # 'Timer' must be already set up as a child node named 'Timer'
        # on the timer's timeout event, call _on_timer_timeout()
        timer.timeout.connect(_on_timer_timeout)
      
      func _on_timer_timeout():
        visible = not visible
      ```
- to add a custom signal
  - ```gd
    signal health_depleted
    # ...
    health_depleted.emit()
    ```
  - ```gd
    signal health_changed(old_value, new_value) # these params show up in Node panel
    # ...
    health_changed.emit(old_health, health) # technically you can pass more params but it's up to you to be consistent in code
    ```
- a `CanvasLayer`'s Inspector panel has a Layer property for a layer number that behaves like [`z-index` in CSS](https://developer.mozilla.org/en-US/docs/Web/CSS/z-index)
  - (very different thing from a collision layer)
- use a `ColorRect` for a solid colour background
- use a `TextureRect` for an image background
- use an `AudioStreamPlayer` for music/sound: Inspector > AudioStreamPlayer > Stream > (you can expand to show more settings, like Loop)
- a `Label`'s font can be set in: Inspector > Control > Theme Overrides > Fonts
- a `Label`'s size can be set in: Inspector > Control > Layout > Transform > Size
- to see predefined actions or create custom-named action bindings that map to multiple input devices: Project > Project settings > Input Map
- set a `Button`'s keyboard shortcut with: Inspector > BaseButton > Shortcut > set Shortcut = Shortcut > expand to show Events > Add Element > expand an element > Action = (what was set in Project > Project settings > Input Map > ...choose a name of an Action, which can be triggered by multiple different keys/etc.)
- 2D: units = pixels; 3D: units = meters.
- you can't really precisely size an `Area` or `RigidBody` or `Sprite`,
  - but you can scale an `AnimatedSprite2D` in: Inspector > Node2D > Transform > Scale
  - after you set a respective `CollisionShape2D`'s size in: Inspector > CollisionShape2D > set dimensions after you choose a Shape
- if you need very low wait times, consider a process loop in a script instead of a `Timer`
- if you want to be able to delete all mobs, including those from previous rounds:
  - click on a node > Node panel > Groups > Add a group named "mobs" (this will let the code differentiate mob from ground collisions)
  - add in main script: `get_tree().call_group("mobs", "queue_free")` to call `queue_free` on all nodes that are part of group `"mobs"` to delete themselves
- `CharacterBody3D` = `Area` or `RigidBody`, but 3D and controlled by player instead of by physics engine
  - consider adding child `Node3D` as pivot named `Pivot`
    - consider adding child `Node3D` as character 3D model named `Character`, e.g. a .glb file, which can be exported from Blender by exporting to GLTF
  - consider adding child `CollisionShape3D` named `CollisionShape` to collide with environment
  - consider adding child `Area3D` named `MobDetector` to detect collisions with other characters, but with "Monitorable" prop unchecked so other nodes can't detect it
    - consider adding several children `CollisionShape3D`s to the `MobDetector` `Area3D`
  - consider adding child `AnimationPlayer`
- `CharacterBody3D` has a native `move_and_slide()` function you can call at the end of your `func _physics_process(delta):` to smooth out motion
- `CharacterBody3D` has a native `look_at_from_position(start_position, position_of_target_to_face_towards, Vector3.UP)` function (3rd param = which way is up axis to rotate around)
- `CharacterBody3D` has a native `rotate_y(randf_range(-PI / 4, PI / 4))` function that you can call after `look_at_from_position` to further adjust rotation
- `CharacterBody3D` has a native `is_on_floor()` function
- rotate the player with `basis = Basis.looking_at(direction)`
- collision layers:
  - **layer** = the "group"/layer the node is in; **mask** = the "group(s)"/layer(s) the node can collide with/listen to.
  - you can add custom names to collision layers: Project > Project Settings... > General > Layer Names > 3D Physics.
    - the layers still display as numbers, but the tooltips will show the custom names.
    - but you can also see checkboxes next to the custom names <- if you click on the 3 dots next to the layers number boxes.
- collision note: `move_and_slide()` makes the node move sometimes multiple times in a row to smooth out the motion. so loop over all collisions in `get_slide_collision_count()` to check (`break` the loop if needed).
- `VisibleOnScreenNotifier3D` child node can tell its parent when it's off-screen (it has its own box), e.g. to despawn an off-screen mob with `queue_free()` on the parent to save on memory when the child `VisibleOnScreenNotifier3D` fires a `screen_exited()` signal
- you can set the viewport size with: Project > Project Settings... > General > Display > Window > Size > Viewport Width and Viewport Height
- unlike 2D, Y-axis positive is **_up_** in 3D. Y-axis positive is **_down_** in 2D.
- unlike 2D, need a camera to be able to see things in a 3D scene:
  - `Marker3D` as camera pivot (in the center viewport, you can see scene and preview with: View > 2 Viewports (Alt))
    - `Camera3D` as camera view (in the center viewport, you can see a Preview checkbox under Perspective, if the `Camera3D` is selected)
- `Camera3D`'s `Size` property in Inspector lets you see wider
- _orthogonal_ camera's `Far` value affects directional shadow quality:
  - big `Far`: see farther, but worse shadows because rendering over bigger distance (shadows may be blurry)
  - small `Far`, e.g `100`: better shadow quality, but can't see farther-away objects
- for how to place points on a `Path3D`, see the instructions+images at https://docs.godotengine.org/en/stable/getting_started/first_3d_game/05.spawning_mobs.html
  - spawn points setup: `PathFollow3D` node as _child_ of `Path3D` node; `Path` = path, `PathFollow` = to select locations on that path

## more example GDScripts:

```gd
extends Sprite2D

# instance member variables:
var speed = 400
var angular_speed = PI # godot defaults rad angles

# Called when the node enters the scene tree for the first time.
func _ready():
  print('Hello World!')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): # use _physics_process for more consistent/smoother physics timing
  var change = angular_speed * delta
  rotation += change # rotation is a built-in property of Sprite2D
  var velocity = Vector2.UP.rotated(rotation) * speed
  position += velocity * delta # rotation is a built-in property of Sprite2D
  # note: you can set a constant rotation on a RigidBody2D in the Inspector panel with: Angular > Velocity
```

use `func _unhandled_input(event):` or use `func _process(delta):`/`func _physics_process(delta):` with things like `Input.is_action_pressed("ui_left")`

```gd
extends Sprite2D
var speed = 400
func _process(delta): # use _physics_process for more consistent/smoother physics timing
  var direction = 0
  if Input.is_action_pressed("ui_left"): # arrows on keyboard or D-pad
    direction = -1
  if Input.is_action_pressed("ui_right"):
    direction = 1
  if Input.is_action_pressed("ui_up"): # not elif, so you can move diagonally
    pass
  if Input.is_action_pressed("ui_down"):
    pass
  position += Vector2.RIGHT * direction * speed * delta
```

- `@export var speed = 400` lets you show the `speed` variable in the Inspector
  - **NOTE:** changing the value in the Inspector overrides this value in the script!

```gd
var speed = 400
var screen_size

func _ready():
  screen_size = get_viewport_rect().size

func _process(delta): # use _physics_process for more consistent/smoother physics timing
  var velocity = Vector2.ZERO
  if Input.is_action_pressed(&"ui_right"): # use a StringName &"..." for faster comparison than a regular String "..."
    velocity.x += 1
  if Input.is_action_pressed(&"ui_left"):
    velocity.x -= 1
  if Input.is_action_pressed(&"ui_down"):
    velocity.y += 1
  if Input.is_action_pressed(&"ui_up"):
    velocity.y -= 1
  if velocity.length() > 0:
    velocity = velocity.normalized() * speed # so diagonal is same speed as orthogonal
    $AnimatedSprite2D.play() # $AnimatedSprite2D is shorthand for getting children with get_node('AnimatedSprite2D')
  else:
    $AnimatedSprite2D.stop()
  
  position += velocity * delta
  
  # keep in screen:
  position = position.clamp(Vector2.ZERO, screen_size)
```

```gd
# to rotate sprite "up" animation in 8 directions:
$AnimatedSprite2D.animation = &"up"
if velocity.x < 0 and velocity.y < 0:
  rotation = - PI * 1/4
elif velocity.x == 0 and velocity.y < 0:
  rotation = 0
elif velocity.x > 0 and velocity.y < 0:
  rotation = PI * 1/4
elif velocity.x < 0 and velocity.y == 0:
  rotation = - PI * 1/2
elif velocity.x > 0 and velocity.y == 0:
  rotation = PI * 1/2
elif velocity.x < 0 and velocity.y > 0:
  rotation = - PI * 3/4
elif velocity.x == 0 and velocity.y > 0:
  rotation = PI
elif velocity.x > 0 and velocity.y > 0:
  rotation = PI * 3/4
```

```gd
signal hit

func _on_body_entered(body):
  hit.emit()
  # must defer setting value of physics properties in a physics callback (to avoid error if while processing a collision):
  $CollisionShape2D.set_deferred("disabled", true)
```

```gd
your_array.pick_random() # instead of your_array[randi() % your_array.size()]
```

```gd
queue_free() # vs free()
```

```gd
# Main.gd:

# so you can use the Inspector panel to select a node, to let you use it in this code as a property/variable mob_scene:
@export var mob_scene: PackedScene

# so you can then create instances of that node whenever you want:
var mob = mob_scene.instantiate() # like inside of func _on_mob_timer_timeout():

# and set random location along a PathFollow2D: (setup: PathFollow inside Path; Path = path, PathFollow = location on path):
var mob_spawn_location = $MobPath/MobSpawnLocation
# or var mob_spawn_location = get_node(^"MobPath/MobSpawnLocation")
mob_spawn_location.progress = randi() # or randf()
mob.position = mob_spawn_location.position
# ...

add_child(mob) # to add the mob instance to the Main scene (run this line in Main.gd)
```

```gd
var random_between_inclusive = randf_range(-PI / 4, PI / 4)
```

```gd
$MessageTimer.start()
await $MessageTimer.timeout
# after waiting, then can do something else
```

```gd
# basically "sleep" or "delay": create a one-shot timer for 1.0 second and await for it to finish:
await get_tree().create_timer(1.0).timeout # instead of using a Timer node
```

Debugging tips from DevWorm: https://www.youtube.com/watch?v=PB6YPnRAyjE

- ```gd
  func _input(event: InputEvents):
    if event.is_action_pressed('1') and OS.is_debug_build():
      print('-----------------')
      print('a', a)
      print('few', few)
      print('vars', vars) # at the same time
      print('-----------------')
  ```
- ```gd
  push_error('this error message shows up in the Errors tab and is clickable to go to the place in the code')
  # or you can also use breakpoints, then step into or step over (in Debugger)
  ```
- there are lots of toggle under the Debug menu for things like "Visible Collision Shapes" or "Visible Paths"

3D:

```gd
extends CharacterBody3D

signal hit

@export var speed = 14 # meters per second
@export var jump_impulse = 20 # big = unrealistic but responsive feels good
@export var bounce_impulse = 16
@export var fall_acceleration = 75 # i.e. gravity


func _physics_process(delta): # better than _process(delta) for physics
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		basis = Basis.looking_at(direction) # use built-in basis property to rotate the player
    $AnimationPlayer.speed_scale = 4 # speed up animation
	else:
		$AnimationPlayer.speed_scale = 1

	velocity.x = direction.x * speed # left/right
	velocity.z = direction.z * speed # forward/back

	# velocity.y + jumping up:
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_impulse

	# velocity.y - falling down:
	velocity.y -= fall_acceleration * delta

  move_and_slide() # to smooth out physics motion

	# Here, we check if we landed on top of a mob and if so, we kill it and bounce.
	# With move_and_slide(), Godot makes the body move sometimes multiple times in a row to
	# smooth out the character's motion. So we have to loop over all collisions that may have
	# happened.
	# If there are no "slides" this frame, the loop below won't run.
	for index in range(get_slide_collision_count()): # check all collisions over move_and_slide():
		var collision = get_slide_collision(index)
		if collision.get_collider().is_in_group("mob"): # if hit mob:
			var mob = collision.get_collider()
			if Vector3.UP.dot(collision.get_normal()) > 0.1: # if the collision happened roughly above the mob:
				mob.squash() # call the custom squash() function of that mob instance's Mob.gd script
				velocity.y = bounce_impulse
				break # escape the for-loop to avoid over-counting squashing 1 mob

	# this makes the character follow a nice arc when jumping:
	rotation.x = PI / 6 * velocity.y / jump_impulse


func die():
	hit.emit() # emit custom signal
	queue_free() # clear this node from memory


func _on_MobDetector_body_entered(_body):
	die()
```
