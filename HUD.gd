extends CanvasLayer

signal start_game

var volume = 0

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Perdu!")
	yield($MessageTimer, "timeout")
	
	$MessageLabel.text = "Dodge the \nCreeps!"
	$MessageLabel.show()
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	$HBoxContainer.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func update_score_max(scoreMax):
	$ScoreMaxLabel.text = str(scoreMax)

func _on_MessageTimer_timeout():
	$MessageLabel.hide()


func _on_StartButton_pressed():
	$StartButton.hide()
	$HBoxContainer.hide()
	emit_signal("start_game")


func _on_MusicSlider_value_changed(value):
	volume = value
