extends Node

func _ready() -> void: # Entry point
	print("Starting to wait")
	for i in 10:
		await get_tree().create_timer(1).timeout
		print(i+1)
	queue_free() # REPL stops excution if this instance no longer exists
