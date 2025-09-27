extends Control

@onready var card_back: Polygon2D = $Card/cardBack
@onready var card_color: Polygon2D = $Card/cardBack/cardColor
@onready var label_tl: Label = $Card/LabelTL
@onready var label_tr: Label = $Card/LabelTR
@onready var label_bl: Label = $Card/LabelBL
@onready var label_br: Label = $Card/LabelBR
@onready var label_middle: Label = $Card/LabelMiddle
@onready var threat_level: HBoxContainer = $Card/ThreatLevel

@onready var threat_level_2: HBoxContainer = $Card/ThreatLevel2

signal cardClicked(values)

const THREATICON = preload("uid://hxpnd86hdlwp")

var myvalues: Array

func update_card_appearance(card):
	myvalues = card
	label_tl.text = str(card[0])
	label_tr.text = str(card[0])
	label_bl.text = str(card[0])
	label_br.text = str(card[0])
	label_middle.text = str(card[0])
	for i in range(0, card[1] - 1):
		var threaticon = THREATICON.instantiate()
		threat_level.add_child(threaticon)
		var threaticon2 = THREATICON.instantiate()
		threat_level_2.add_child(threaticon2)


func _on_self_clicked(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("Clicked on card with number ", myvalues[0], " and it's worth ", myvalues[1], " points")
		emit_signal("cardClicked", myvalues)
