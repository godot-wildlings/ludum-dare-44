extends TabContainer

var story_tabs = self
signal story_completed


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("story_completed", Game.main, "_on_story_completed")

	initialize_fields()


func initialize_fields():
	#$Tab3/VBoxContainer/PlayerNameEntry.set_text(Game.player.player_name)
	pass


func _on_NextTabButton_pressed():
	if story_tabs.get_current_tab() < story_tabs.get_tab_count()-1:
		story_tabs.set_current_tab(story_tabs.get_current_tab()+1)
	else:
		emit_signal("story_completed")


func _on_PlayerNameEntry_text_entered(new_text):
	Game.player.player_name = new_text
	var IntroText2 = $Tab3/VBoxContainer/IntroText2
	IntroText2.set_text(IntroText2.get_text().replace("<playername>", Game.player.player_name))

