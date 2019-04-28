extends Control

class_name CraftingLab

export var creature_tscn : PackedScene = preload("res://Scenes/Creature/Creature.tscn") as PackedScene
#warning-ignore:unused_class_variable
onready var body_parts : ItemList = $Control/HBoxContainer/VBoxContainer/BodyParts
#warning-ignore:unused_class_variable
onready var staged_body_parts : ItemList = $Control/HBoxContainer/VBoxContainer2/StagedBodyParts
#warning-ignore:unused_class_variable
onready var preview_container : Node2D = $Control/HBoxContainer/MarginContainer/CreaturePreviewContainer
#warning-ignore:unused_class_variable
onready var craft_creature_button : Button = $Control/HBoxContainer/VBoxContainer2/CraftCreatureButton
onready var creature_name_input : LineEdit = $Control/HBoxContainer/VBoxContainer2/CreatureNameInput
onready var creature_name_label : Label = $Control/CraftingTube/CreatureNameLabel


var creature_name : String = "CREATURE"

signal crafting_completed

func _ready() -> void:
	Game.crafting_lab = self
	#warning-ignore:return_value_discarded
	craft_creature_button.connect("pressed", self, "_on_CraftCreatureButton_pressed")
	#warning-ignore:return_value_discarded
	connect("crafting_completed", self, "_on_CraftingLab_crafting_completed")

	if not creature_name_input.is_connected("text_changed", self, "_on_CreatureNameInput_text_changed"):
		creature_name_input.connect("text_changed", self, "_on_CreatureNameInput_text_changed")

func _on_CraftingLab_crafting_completed() -> void:
	pass
	# relocated to Go to studio button
	#_save_crafted_creature()

func _craft_creature() -> void:
	# clean up the leftovers from the previous creation
	for children in preview_container.get_children():
		preview_container.remove_child(children)
	var amount_of_staged_body_parts : int = staged_body_parts.get_item_count()
	if amount_of_staged_body_parts > 0:
		# instantiate a creature background and put proper body parts in place
		var creature : Object = creature_tscn.instance()
		preview_container.add_child(creature)
		for i in range(amount_of_staged_body_parts):
			var body_part : BodyPart = DataStore.get_body_part(staged_body_parts.get_item_text(i))
			if is_instance_valid(body_part):
				var spawned_body_part : Sprite = Sprite.new()
				creature.add_child(spawned_body_part)
				spawned_body_part.texture = body_part.icon
				body_parts.add_item(body_part.part_name, body_part.icon)
		staged_body_parts.clear()

		creature_name_label.text = preview_container.get_child(0).name
		emit_signal("crafting_completed")
#		print(self.name, " creature name == ", DataStore.crafted_creatures[DataStore.crafted_creatures.size()-1].creature_name)
#		creature_name_label.text = DataStore.crafted_creatures[DataStore.crafted_creatures.size()-1].creature_name


func _save_crafted_creature() -> void:
	if preview_container.get_child_count() < 1:
		print("Could not get creature node from CreaturePreviewContainer")
	else:
		var creature : Creature = preview_container.get_child(0)
		creature.creature_name = creature_name
		DataStore.crafted_creatures.append(creature)

		relocate_creature_to_storage(creature)

		print(DataStore.crafted_creatures)

func relocate_creature_to_storage(creature):
	# prevent creature from queuing_free when the lab level is freed
	creature.get_parent().remove_child(creature)
	Game.main.add_creature_to_storage(creature)

func _on_CraftCreatureButton_pressed() -> void:
	_craft_creature()




func _on_ReturnToMainButton_pressed():
	_save_crafted_creature()
	Game.main.return_to_main()



func _on_OnToStudioButton_pressed():
	_save_crafted_creature()
	Game.main.load_level("Stream")


func _on_CreatureNameInput_text_changed(new_text):
	if new_text != "" and new_text != null:
		creature_name = new_text
		craft_creature_button.disabled = false

