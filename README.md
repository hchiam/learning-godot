# Learning Godot (game engine)

Just one of the things I'm learning. https://github.com/hchiam/learning

https://www.youtube.com/watch?v=QKgTZWbwD1U

https://github.com/godotengine/godot

intro: https://docs.godotengine.org/en/stable/getting_started/introduction/index.html 

networking and physics: https://docs.godotengine.org/en/stable/tutorials/best_practices/introduction_best_practices.html

GDScript: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/index.html#toc-learn-scripting-gdscript

## miscellaneous notes

- in my mind, there's only 2 core concepts in godot: nodes and signals:
  - scenes are the same thing as nodes. everything's nested in trees of nodes. simpler than thinking in MVC (Model-View-Controller).
  - signals enable "notification" callbacks. a node sends out a signal, and you can attach nodes to listen to that signal.
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
- example GDScript:
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
    ```
