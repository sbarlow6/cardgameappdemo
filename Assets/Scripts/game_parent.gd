extends Node2D

var cardArray: Array = []
var deck: Array

var player1Hand: Array
var player2Hand: Array
var player3Hand: Array
var player4Hand: Array

var player1ChosenCard: Array
var player2ChosenCard: Array
var player3ChosenCard: Array
var player4ChosenCard: Array

var playershands: Array = [player1Hand, player2Hand, player3Hand, player4Hand]

@onready var hbox_row_1: HBoxContainer = $CurrentRows/Row1
@onready var hbox_row_2: HBoxContainer = $CurrentRows/Row2
@onready var hbox_row_3: HBoxContainer = $CurrentRows/Row3
@onready var hbox_row_4: HBoxContainer = $CurrentRows/Row4

@onready var hbox_rows: Array = [hbox_row_1, hbox_row_2, hbox_row_3, hbox_row_4]

var value_row_1: Array
var value_row_2: Array
var value_row_3: Array
var value_row_4: Array

var value_rows: Array = [value_row_1, value_row_2, value_row_3, value_row_4]

var current_turn: int = 0

#@onready var card: Node2D = $CurrentPlayersHand/Control/Card
@onready var current_players_hand: HBoxContainer = $CurrentPlayersHand
const CARD_CONTROL = preload("uid://bcr17eg16mec")
@onready var turn_label: Label = $TurnLabel


func _ready() -> void:
	for i in range(1, 105):
		#print("loop ", i)
		var pointvalue: int = 1
		if i%5 == 0:
			pointvalue = 2
		if i%10 == 0:
			pointvalue = 3
		if i%11 == 0:
			pointvalue = 5
		if i == 55:
			pointvalue = 7
		var newCard: Array = [i, pointvalue]
		cardArray.append(newCard)
		deck = cardArray.duplicate()
		deck.shuffle()
	print(deck)
	for i in range(0, 40):
		print("This card goes to player ", i%4)
		playershands[i%4].append(deck[0])
		deck.remove_at(0)
	print(playershands[3])
	switch_hands(current_turn%4)
	for i in range(0, 4):
		if !hbox_rows[i]:
			await hbox_rows[i].is_ready
		var new_card = CARD_CONTROL.instantiate()
		hbox_rows[i].add_child(new_card)
		new_card.update_card_appearance(deck[0])
		value_rows[i].append(deck[0])
		deck.remove_at(0)
	#card.update_card_appearance(player4Hand[0])

func process_card_choice(value):
	print("PLAYER 1 Chose card ", value)
	playershands[current_turn%4].erase(value)
	player1ChosenCard = value
	current_turn += 1
	if current_turn%4 == 0:
		print("ALL PLAYERS HAVE CHOSEN A CARD. NOW WE NEED TO RESOLVE THE CHOICES")
	switch_hands(current_turn%4)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_right"):
		current_turn += 1
		switch_hands(current_turn%4)
		
	
func switch_hands(player):
	turn_label.text = "Player " + str(player + 1) + "'s turn"
	for i in current_players_hand.get_children():
		i.queue_free()
	
	for i in playershands[player]:
		var new_card = CARD_CONTROL.instantiate()
		current_players_hand.add_child(new_card)
		new_card.cardClicked.connect(process_card_choice)
		new_card.update_card_appearance(i)
