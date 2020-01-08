extends CanvasLayer

var score = 0

func show_message(text):
	$Message.text = text
	$MessageAnimation.play("show_message")

func hide():
	$ScoreBox.hide()
	$BonusBox.hide()
	$Message.hide()

func show():
	$ScoreBox.show()
	$BonusBox.show()
	$Message.show()

func update_score(value):
	$ScoreBox/HBoxContainer/Score.text = str(value)

func update_bonus(value):
	$BonusBox/Bonus.text = str(value) + "x"
	if value > 1:
		$BonusAnimation.play("bonus")
