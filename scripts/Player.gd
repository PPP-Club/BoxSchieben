extends Node2D

var playerTilemap: TileMap
var essTilemap: TileMap
var output: Label
const waterChar := 0
const fireChar := 5 

const airChar := -1
const boxChar := 1
const finishChar := 2

const map :=   ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 
				'X', ' ', ' ', ' ', ' ', 'X', 'X', 'X', ' ', ' ', 'X', 'X', 
				'X', ' ', 'B', ' ', ' ', 'X', 'X', 'X', ' ', 'B', 'X', 'X', 
				'X', 'X', 'X', 'X', ' ', ' ', ' ', ' ', ' ', ' ', 'X', 'X', 
				'X', 'X', 'X', ' ', ' ', ' ', 'X', 'X', 'X', ' ', 'X', 'X', 
				'X', '2', ' ', ' ', ' ', ' ', 'X', 'X', ' ', ' ', ' ', 'X', 
				'X', ' ', ' ', ' ', '1', 'X', 'X', 'X', ' ', ' ', ' ', 'X', 
				'X', ' ', 'B', ' ', ' ', 'X', 'X', 'X', ' ', ' ', ' ', 'X', 
				'X', ' ', ' ', ' ', ' ', 'X', 'X', 'X', 'F', 'F', 'F', 'X', 
				'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', ]

func _ready():
	playerTilemap = $mainTileMap
	essTilemap = $essentialTileMap
	output = $Label
	genMap(map, 12)

func genMap(mapArray: PoolStringArray, lineLengh: int):
	var arrayLengh := mapArray.size()
	for pos in range(arrayLengh):
		var y = pos / lineLengh
		var x = pos - (y * lineLengh)
		tilemap.set_cell(x, y, _getTileByString(mapArray[pos]))

func _getTileByString(key: String):
	match key:
		' ':
			return -1
		'X':
			return 3
		'B':
			return 1
		'1':
			return 0
		'2':
			return 5
		'F':
			return 2
		'G':
			return 4

func _process(delta):
	var finishPoints = essTilemap.get_used_cells_by_id(finishChar);
	if(!finishPoints):
		output.text = "You Won!";

# warning-ignore:unused_argument
func _input(event):
	var oldPlayerPosFire = playerTilemap.get_used_cells_by_id(fireChar)[0];
	var oldPlayerPosWater = playerTilemap.get_used_cells_by_id(waterChar)[0];
	var newPlayerPos = [];

	# CALCULATION PROCESS OF NEW PLAYERPOS #
	if Input.is_key_pressed(KEY_W):
		newPlayerPos = [oldPlayerPosFire[0], oldPlayerPosFire[1] - 1, fireChar]
	elif Input.is_key_pressed(KEY_S):
		newPlayerPos = [oldPlayerPosFire[0], oldPlayerPosFire[1] + 1, fireChar]
	elif Input.is_key_pressed(KEY_A):
		newPlayerPos = [oldPlayerPosFire[0] - 1, oldPlayerPosFire[1], fireChar]
	elif Input.is_key_pressed(KEY_D):
		newPlayerPos = [oldPlayerPosFire[0] + 1, oldPlayerPosFire[1], fireChar]
	
	elif Input.is_key_pressed(KEY_UP):
		newPlayerPos = [oldPlayerPosWater[0], oldPlayerPosWater[1] - 1, waterChar]
	elif Input.is_key_pressed(KEY_DOWN):
		newPlayerPos = [oldPlayerPosWater[0], oldPlayerPosWater[1] + 1, waterChar]
	elif Input.is_key_pressed(KEY_LEFT):
		newPlayerPos = [oldPlayerPosWater[0] - 1, oldPlayerPosWater[1], waterChar]
	elif Input.is_key_pressed(KEY_RIGHT):
		newPlayerPos = [oldPlayerPosWater[0] + 1, oldPlayerPosWater[1], waterChar]
	
	# MOVE PLAYER #
	if newPlayerPos.size() != 0 && (playerTilemap.get_cell(newPlayerPos[0], newPlayerPos[1]) == airChar && essTilemap.get_cell(newPlayerPos[0], newPlayerPos[1]) == airChar || essTilemap.get_cell(newPlayerPos[0], newPlayerPos[1]) == finishChar):
		playerTilemap.set_cell(newPlayerPos[0], newPlayerPos[1], newPlayerPos[2])

		if newPlayerPos[2] == fireChar:
			playerTilemap.set_cell(oldPlayerPosFire[0], oldPlayerPosFire[1], airChar)
		elif newPlayerPos[2] == waterChar:
			playerTilemap.set_cell(oldPlayerPosWater[0], oldPlayerPosWater[1], airChar)
		else:
			print("ERROR: Couldn't remove old Player")
	
	# NEW POS IS BOX => MOVE BOX AND PLAYER #
	elif newPlayerPos.size() != 0 && essTilemap.get_cell(newPlayerPos[0], newPlayerPos[1]) == boxChar:
		var oldBoxPos = newPlayerPos;
		var newBoxPos;
		
		if newPlayerPos[2] == fireChar:
			newBoxPos = [oldBoxPos[0] + (newPlayerPos[0] - oldPlayerPosFire[0]), oldBoxPos[1] + (newPlayerPos[1] - oldPlayerPosFire[1])]
		elif newPlayerPos[2] == waterChar:
			newBoxPos = [oldBoxPos[0] + (newPlayerPos[0] - oldPlayerPosWater[0]), oldBoxPos[1] + (newPlayerPos[1] - oldPlayerPosWater[1])]
		
		if essTilemap.get_cell(newBoxPos[0], newBoxPos[1]) == airChar && playerTilemap.get_cell(newBoxPos[0], newBoxPos[1]) == airChar || essTilemap.get_cell(newBoxPos[0], newBoxPos[1]) == finishChar:
			essTilemap.set_cell(newBoxPos[0], newBoxPos[1], boxChar);
			essTilemap.set_cell(oldBoxPos[0], oldBoxPos[1], airChar);

			if newPlayerPos.size() != 0 && playerTilemap.get_cell(newPlayerPos[0], newPlayerPos[1]) == airChar:
				playerTilemap.set_cell(newPlayerPos[0], newPlayerPos[1], newPlayerPos[2])

			if newPlayerPos[2] == fireChar:
				playerTilemap.set_cell(oldPlayerPosFire[0], oldPlayerPosFire[1], airChar)
			elif newPlayerPos[2] == waterChar:
				playerTilemap.set_cell(oldPlayerPosWater[0], oldPlayerPosWater[1], airChar)
			else:
				print("ERROR: Couldn't remove old Player")
