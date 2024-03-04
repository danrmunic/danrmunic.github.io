extends Node

var chatting
var current_chat

signal area_entered
signal area_exited

func _ready():
	$Gacha/GachaMachineSprite.flip_h = true
	chatting = false

func get_all_children(node) -> Array:
	var nodes : Array = []
	for N in node.get_children():
		if N.get_child_count() > 0:
			nodes.append(N)
			nodes.append_array(get_all_children(N))
		else:
			nodes.append(N)
	return nodes

func _process(delta):
	var children : Array = get_all_children(self)
	for child in children:
		if not (child is Area2D):
			continue
		if not (current_chat == child) and chatting:
			continue
		var in_area = false
		for body in child.get_overlapping_bodies():
			if body.to_string().contains("Player"):
				in_area = true
		if in_area and not chatting:
			chatting = true
			current_chat = child
			area_entered.emit(child)
		if not in_area and chatting:
			chatting = false
			current_chat = null
			area_exited.emit(child)
		
func _on_dialogue_finished():
	pass
