extends Node

func _init() -> void: # Entry point
	print("Starting to wait")
	for i in 10:
		await get_tree().create_timer(1).timeout
		print(i+1)
	queue_free()
