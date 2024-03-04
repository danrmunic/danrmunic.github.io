extends Control

signal dialogue_finished

@export_file("*.json") var d_file

const NPC_NAME_LIST = ["Gacha", "Roly1"]
const DIALOGUE_BOX_OFFSET_X = 1000
const DIALOGUE_BOX_OFFSET_Y = 200

var dialogue = []
var current_dialogue_id = 0
var d_active = false
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	d_active = false
	modulate.a = 0
	#size = get_viewport_rect().size
	
func _process(delta):
	#scale = get_viewport_rect().size
	position = get_viewport_rect().end
	position.x -= DIALOGUE_BOX_OFFSET_X
	position.y -= DIALOGUE_BOX_OFFSET_Y
	
func _start_dialog(NPC_name_full):
	d_active = true
	visible = true
	var NPC_name = parse_npc_name(NPC_name_full)
	dialogue = load_dialogue(NPC_name)
	current_dialogue_id = -1
	fade_in()
	$Name.text = dialogue[0]
	current_dialogue_id += 1
	next_script()
	
func parse_npc_name(NPC_name_full):
	for name in NPC_NAME_LIST:
		if NPC_name_full.contains(name):
			return name
	return ""
	
func fade_in():
	if(modulate.a < 0.2):
		while modulate.a < 1:
			await get_tree().create_timer(0.1).timeout
			modulate.a += 0.2
		
func fade_out():
	if(modulate.a > 0.8):
		while modulate.a > 0:
			await get_tree().create_timer(0.1).timeout
			modulate.a -= 0.2
	
func load_dialogue(NPC_name):
	var file = FileAccess.open(str("res://Dialogue/",NPC_name,"_dialogue.json"), FileAccess.READ)
	#var content = JSON.parse_string(file.get_as_text())
	var content = file.get_as_text()
	var contentarray = content.split("\n")
	contentarray.remove_at(len(contentarray)-1) #The last line will always be empty, remove it
	return contentarray
	
func _input(event):
	if !d_active:
		return
	if event.is_action_pressed("ui_up"):
		next_script()

func next_script():
	current_dialogue_id += 1
	if current_dialogue_id >= len(dialogue):
		dialogue_exit()
		return
	$Text.text = dialogue[current_dialogue_id]

func dialogue_exit():
	fade_out()
	d_active = false
	#visible = false
