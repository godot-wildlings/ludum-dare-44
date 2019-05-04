"""
Objectives:

Show the creatures on a list in the sidebar.
Allow the player to select a creature from the list.
It should appear in the main window.
Allow the player to 'show off' or 'sell' their creature for followers

"""

extends Control


onready var creatures_list = $VBoxContainer/stream_UI/RightSide/CreatureList
onready var display_position = $VBoxContainer/stream_UI/LeftSide/DisplayPosition
onready var appraise_label = $VBoxContainer/stream_UI/LeftSide/VBoxContainer/AppraisedValueLabel
onready var appraise_button = $VBoxContainer/stream_UI/LeftSide/VBoxContainer/HBoxContainer/AppraiseButton
onready var sell_button = $VBoxContainer/stream_UI/LeftSide/VBoxContainer/HBoxContainer/SellButton


var creature_on_display
#var ticks : int = 0

#var trends

func _ready():

	appraise_button.set_disabled(true)
	sell_button.set_disabled(true)

	populate_creature_list()

	check_sweat_equity()


func check_sweat_equity():
	if Game.player.sweat <= 0:
		Game.player.sweat = 0
		appraise_button.set_disabled(true)


func populate_creature_list():
	creatures_list.clear()
	for creature in Game.main.get_stored_creatures():

		creatures_list.add_item(creature.creature_name, null, true)


func _on_ReturnToMainButton_pressed():

	if creature_on_display != null and is_instance_valid(creature_on_display):
		Game.main.store_creature(creature_on_display)
	Game.main.return_to_main()


func _on_CreatureList_item_selected(index):
	if creature_on_display != null and is_instance_valid(creature_on_display):
		Game.main.store_creature(creature_on_display)

	if creatures_list.is_item_selectable(index) and not creatures_list.is_item_disabled(index):
		var creature = Game.main.get_creature_from_storage(index)

		if display_position.get_child_count() > 0:
			for child in display_position.get_children():

#				Game.main.creature_storage_container.add_child(child)

				display_position.remove_child(child)

		creature_on_display = creature
		appraise_button.set_disabled(false)
		sell_button.set_disabled(false)

		display_position.add_child(creature)

		creature.make_noise()

		#creatures_list.clear()
		populate_creature_list()


func _on_SellButton_pressed():
	"""
	determine the value of the creature based on it's genes and current trends
	remove the creature from the stage (it's not currently in storage)
	add followers
	"""

	if creature_on_display != null and is_instance_valid(creature_on_display):
		var income = creature_on_display.get_value()
		Game.player.add_income(income)
		Game.player.tears += 1

		creature_on_display.die()
		creature_on_display = null

		Game.player.sweat = max(Game.player.sweat - 10, 0)
		if Game.player.sweat <= 0:
			show_effort_depleted_dialog()

		# wait for audio
		yield(get_tree().create_timer(0.1), "timeout")
		sell_button.set_disabled(true)



func _on_AppraiseButton_pressed():
	if appraise_button.disabled == false:

		if creature_on_display != null and is_instance_valid(creature_on_display):
			Game.player.sweat = max(Game.player.sweat - 10, 0)
			if Game.player.sweat == 0:
				Game.main.store_creature(creature_on_display)
				show_effort_depleted_dialog()

			appraise_label.set_text(creature_on_display.creature_name + " will probably generate " + str(int(creature_on_display.get_value())) + " followers.")

			# wait for sound
			yield(get_tree().create_timer(0.1), "timeout")
			appraise_button.set_disabled(true)

func show_effort_depleted_dialog():
	$EffortDepletedPopup.show()




func _on_KeepButton_pressed():
	if creature_on_display != null and is_instance_valid(creature_on_display):
		Game.main.store_creature(creature_on_display)
		populate_creature_list()
		sell_button.set_disabled(true)
		appraise_button.set_disabled(true)

