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
	static var CLEAR = "\u001b[H\u001b[2J"
	static var DELETE = "\u001b[P"

var temp_line: String
var script_instance
var file: String
var HELP := "Welcome to GDScREPL - Unoffical REPL for GDScript

If you're not familiar with GDScript, consider reading the reference at
https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html

To quit this program, enter \"q\", \"quit\" or \"exit\".\n"

func _ready() -> void:
	file = OS.get_cmdline_args()[0]
	if FileAccess.file_exists(file) and file.ends_with(".gd"):			
		await run_script_from_string(FileAccess.open(file, FileAccess.READ).get_as_text())
		get_tree().quit(0)
		return
	var GODOT_VERSION = str(Engine.get_version_info()["major"]) + "." + str(Engine.get_version_info()["minor"]) + "." + str(Engine.get_version_info()["patch"])
	print("GDScript " + GODOT_VERSION + " (" + Time.get_date_string_from_system(true) + " " + Time.get_time_string_from_system(true) + ") on " + OS.get_name() + 
			"\nType \"help\" for more information.")
	while(true):
		printraw(colors.LIGHT_BLUE + ">>> " + colors.END)
		temp_line = OS.read_string_from_stdin()
		match temp_line:
			"":
				pass
			"q", "quit", "exit":
				get_tree().quit(0)
				break
			"clear":
				printraw(colors.CLEAR)
			"help":
				print(HELP)
			_:
				await run_script_from_string("func _init(): " + temp_line)
		temp_line = ""

func run_script_from_string(code: String) -> bool:
	var script = GDScript.new()
	script.set_source_code(code)
	if script.reload() != OK:
		return true
	script_instance = ClassDB.instantiate(script.get_instance_base_type())
	add_child(script_instance)
	script_instance.set_script(script)
	await script_instance.tree_exited
	return true
