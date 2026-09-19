extends StaticBody2D

var locked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !locked:
		if get_tree().get_node_count_in_group("enemy") == 0:
			$MeshInstance2D.visible = false
			$CollisionShape2D.disabled = true
		else:
			$MeshInstance2D.visible = true
			$CollisionShape2D.disabled = false
