# Learning Godot (game engine)

Just one of the things I'm learning. https://github.com/hchiam/learning

https://www.youtube.com/watch?v=QKgTZWbwD1U

https://github.com/godotengine/godot

intro: https://docs.godotengine.org/en/stable/getting_started/introduction/index.html 
- intro, 2D: https://docs.godotengine.org/en/stable/getting_started/first_2d_game/index.html + completed [2D tutorial code](https://github.com/godotengine/godot-demo-projects/tree/master/2d/dodge_the_creeps)
- intro, 3D: https://docs.godotengine.org/en/stable/getting_started/first_3d_game/index.html

best practices: https://docs.godotengine.org/en/stable/tutorials/best_practices/introduction_best_practices.html
- physics: https://docs.godotengine.org/en/stable/tutorials/physics/index.html
- networking: https://docs.godotengine.org/en/stable/tutorials/networking/index.html
  - example code for player-hosted lobby: https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html#example-lobby-implementation

GDScript: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/index.html#toc-learn-scripting-gdscript
- For syntax notes on things like `&"` and `^"`, Ctrl+F in this page: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html

## miscellaneous notes

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
- use a `ColorRect` for a solid colour background
- use a `TextureRect` for an image background
- use an `AudioStreamPlayer` for music/sound: Inspector > AudioStreamPlayer > Stream > (you can expand to show more settings, like Loop)
- a `Label`'s font can be set in: Inspector > Control > Theme Overrides > Fonts
- a `Label`'s size can be set in: Inspector > Control > Layout > Transform > Size
- set a `Button`'s keyboard shortcut with: Inspector > BaseButton > Shortcut > set Shortcut = Shortcut > expand to show Events > Add Element > expand an element > Action = (what was set in Project > Project settings > Input Map > ...choose a name of an Action, which can be triggered by multiple different keys/etc.)
- you can't really precisely size an `Area` or `RigidBody` or `Sprite`,
  - but you can scale an `AnimatedSprite2D` in: Inspector > Node2D > Transform > Scale
  - after you set a respective `CollisionShape2D`'s size in: Inspector > CollisionShape2D > set dimensions after you choose a Shape
- if you need very low wait times, consider a process loop in a script instead of a `Timer`
- if you want to be able to delete all mobs, including those from previous rounds:
  - click on a node > Node panel > Groups > Add a group named "mobs"
  - add in main script: `get_tree().call_group("mobs", "queue_free")` to call `queue_free` on all nodes that are part of group `"mobs"` to delete themselves

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
func _process(delta):
  var change = angular_speed * delta
  rotation += change # rotation is a built-in property of Sprite2D
  var velocity = Vector2.UP.rotated(rotation) * speed
  position += velocity * delta # rotation is a built-in property of Sprite2D
  # note: you can set a constant rotation on a RigidBody2D in the Inspector panel with: Angular > Velocity
```

use `func _unhandled_input(event):` or use `func _process(delta):` with things like `Input.is_action_pressed("ui_left")`

```gd
extends Sprite2D
var speed = 400
func _process(delta):
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

func _process(delta):
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
# so you can let the Inspector panel select a node and then use it in this code:
@export var mob_scene: PackedScene

# so you can then create instances of that node whenever you want:
var mob = mob_scene.instantiate()

# and set random location along a PathFollow2D:
var mob_spawn_location = $MobPath/MobSpawnLocation
# or var mob_spawn_location = get_node(^"MobPath/MobSpawnLocation")
mob_spawn_location.progress = randi()
mob.position = mob_spawn_location.position
# ...

add_child(mob)
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
