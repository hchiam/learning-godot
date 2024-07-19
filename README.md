# Learning Godot (game engine)

Just one of the things I'm learning. https://github.com/hchiam/learning

https://www.youtube.com/watch?v=QKgTZWbwD1U

https://github.com/godotengine/godot

intro: https://docs.godotengine.org/en/stable/getting_started/introduction/index.html 
- intro, 2D: https://docs.godotengine.org/en/stable/getting_started/first_2d_game/index.html
- intro, 3D: https://docs.godotengine.org/en/stable/getting_started/first_3d_game/index.html

best practices: https://docs.godotengine.org/en/stable/tutorials/best_practices/introduction_best_practices.html
- physics: https://docs.godotengine.org/en/stable/tutorials/physics/index.html
- networking: https://docs.godotengine.org/en/stable/tutorials/networking/index.html
  - example code for player-hosted lobby: https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html#example-lobby-implementation

GDScript: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/index.html#toc-learn-scripting-gdscript

## miscellaneous notes

- in my mind, there's only 2 core concepts in godot: nodes and signals:
  - scenes are the same thing as nodes. everything's nested in trees of nodes. simpler than thinking in MVC (Model-View-Controller).
  - signals enable "notification" callbacks (observer pattern). a node sends out a signal, and you can attach nodes to listen to that signal.
- cmd + b = run from main
- cmd + r = run current scene
- cmd + . = stop runing
- **_cmd + shift + A_**
  - = "import" an _instance_ of an other scene as a child node, which packages/hides that other scene's own children from view of the current scene
  - you have to save the original instance for the "imported" instances to update to match
  - you can customize one of those instances, which overrides the original instance's properties
    - you can show an instance's children with: right-click > checkmark Editable Children
  - you can customize one of those instances' PhysicsMaterial (a resource) in the Inspector panel with: down arrow dropdown > Make Unique > props unlocked!
- cmd + d = duplicate
- cmd + c --> cmd + v = create child
- you can mix scripting languages as needed (e.g. use C# only to implement complex algorithms with better performance)
- to add an image as a texture to a Sprite2D: Inspector > Texture > click to show dropdown > Load...
- to add a script to a node: Scene > right-click > Attach Script...
- example GDScripts:
  - ```gd
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
  - use `func _unhandled_input(event):` or use `func _process(delta):` with things like `Input.is_action_pressed("ui_left")`
    - ```gd
      extends Sprite2D
      var speed = 400
      func _process(delta):
        var direction = 0
        var velocity = Vector2.ZERO
        if Input.is_action_pressed("ui_left"): # arrows on keyboard or D-pad
          direction = -1
        elif Input.is_action_pressed("ui_right"):
          direction = 1
        position += Vector2.RIGHT * direction * speed * delta
      ```
- connect a signal:
  - through the editor: select a node > Node panel > double-click a signal for that node > select a node that has a script (a receiver method will be auto-named) > Connect
    - the **_listener_**/target node will have the callback written in its script
    - ```gd
      func _on_button_pressed(): # you'll see a "->]" icon on the left side of this func
  	    set_process(not is_processing()) # toggle whether _process(delta) is running
      ```
  - through code (needed when creating nodes inside of a script):
    - ```gd
      func _ready():
        var timer: Timer = get_node('Timer') # 'Timer' must be already set up as a child node named 'Timer'
        # on the timer's timeout event, call _on_timer_timeout()
        timer.timeout.connect(_on_timer_timeout)
      
      func _on_timer_timeout():
        visible = not visible
      ```
- custom signal
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
