extends Node

class colors:
	static var BLACK = "\u001b[0;30m"
	static var RED = "\u001b[0;31m"
	static var GREEN = "\u001b[0;32m"
	static var BROWN = "\u001b[0;33m"
	static var BLUE = "\u001b[0;34m"
	static var PURPLE = "\u001b[0;35m"
	static var CYAN = "\u001b[0;36m"
	static var LIGHT_GRAY = "\u001b[0;37m"
	static var DARK_GRAY = "\u001b[1;30m"
	static var LIGHT_RED = "\u001b[1;31m"
	static var LIGHT_GREEN = "\u001b[1;32m"
	static var YELLOW = "\u001b[1;33m"
	static var LIGHT_BLUE = "\u001b[1;34m"
	static var LIGHT_PURPLE = "\u001b[1;35m"
	static var LIGHT_CYAN = "\u001b[1;36m"
	static var LIGHT_WHITE = "\u001b[1;37m"
	static var BOLD = "\u001b[1m"
	static var FAINT = "\u001b[2m"
	static var ITALIC = "\u001b[3m"
	static var UNDERLINE = "\u001b[4m"
	static var BLINK = "\u001b[5m"
	static var NEGATIVE = "\u001b[7m"
	static var CROSSED = "\u001b[9m"
	static var END = "\u001b[0m"

var temp_line

func _ready() -> void:
	for i in OS.get_cmdline_args():
		if FileAccess.file_exists(i) and i.ends_with(".gd"):			
			await run_script_from_string(FileAccess.open(i, FileAccess.READ).get_as_text())
			get_tree().quit()
			return
	print("GDScript 4.5.1.stable (" + Time.get_date_string_from_system() + " " + Time.get_time_string_from_system() + ") on " + OS.get_name())
	while(true):
		printraw(colors.LIGHT_BLUE + ">>> " + colors.END)
		temp_line = OS.read_string_from_stdin()
		if temp_line != "":
			await run_script_from_string("extends Node; func _ready() -> void: " + temp_line + "; queue_free()")
		temp_line = ""

func run_script_from_string(code: String) -> bool:
	var script = GDScript.new()
	script.set_source_code(code)
	if script.reload() != OK:
		return true
	var script_instance = Node.new()
	add_child(script_instance)
	script_instance.set_script(script)
	script_instance.call("_ready")
	await script_instance.tree_exited
	return true
