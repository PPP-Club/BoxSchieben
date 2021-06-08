extends Node2D

var playerTilemap: TileMap
var essTilemap: TileMap
var output: Label
const waterChar := 0
const fireChar := 5

var mapgenerator: Node2D

const airChar := -1
const boxChar := 1
const finishCharBlue := 4
const finishCharRed := 2

const map :=   ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 
				'X', ' ', ' ', ' ', ' ', 'X', 'X', 'X', ' ', ' ', 'X', 'X', 
				'X', ' ', '1', ' ', 'B', 'X', 'X', 'X', ' ', 'B', 'X', 'X', 
				'X', 'X', 'X', 'X', ' ', ' ', ' ', ' ', ' ', ' ', 'X', 'X', 
				'X', 'X', 'X', ' ', ' ', ' ', 'X', 'X', 'X', ' ', 'X', 'X', 
				'X', ' ', ' ', ' ', 'B', ' ', 'X', 'X', ' ', ' ', ' ', 'X', 
				'X', ' ', ' ', ' ', ' ', 'X', 'X', 'X', ' ', ' ', ' ', 'X', 
				'X', ' ', '2', ' ', ' ', 'X', 'X', 'X', ' ', ' ', ' ', 'X', 
				'X', ' ', ' ', ' ', ' ', 'X', 'X', 'X', 'F', 'G', 'F', 'X', 
				'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X']

func _ready():
	playerTilemap = $mainTileMap
	essTilemap = $essentialTileMap
	output = $Label
	mapgenerator = $MapGen
	mapgenerator.genMap(map, 12, essTilemap, playerTilemap)

func _process(delta):
	pass

# warning-ignore:unused_argument
func _input(event):
	if(!playerTilemap.get_used_cells_by_id(fireChar)):
		return
	
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
	
	if newPlayerPos.size() == 0: return
	
	var playerPosInEss = essTilemap.get_cell(newPlayerPos[0], newPlayerPos[1])
	var playerPosInMain = playerTilemap.get_cell(newPlayerPos[0], newPlayerPos[1])
	
	var isAir = playerPosInMain == airChar && playerPosInEss == airChar
	var isFinish = playerPosInEss == finishCharRed || playerPosInEss == finishCharBlue

	# MOVE PLAYER #
	if isAir || isFinish && playerPosInMain != boxChar:
		playerTilemap.set_cell(newPlayerPos[0], newPlayerPos[1], newPlayerPos[2])

		if newPlayerPos[2] == fireChar:
			playerTilemap.set_cell(oldPlayerPosFire[0], oldPlayerPosFire[1], airChar)
		elif newPlayerPos[2] == waterChar:
			playerTilemap.set_cell(oldPlayerPosWater[0], oldPlayerPosWater[1], airChar)
		else:
			print("ERROR: Couldn't remove old Player")
	
	# NEW POS IS BOX => MOVE BOX AND PLAYER #
	elif newPlayerPos.size() != 0 && playerTilemap.get_cell(newPlayerPos[0], newPlayerPos[1]) == boxChar:
		var oldBoxPos = newPlayerPos;
		var newBoxPos;
		
		if newPlayerPos[2] == fireChar:
			newBoxPos = [oldBoxPos[0] + (newPlayerPos[0] - oldPlayerPosFire[0]), oldBoxPos[1] + (newPlayerPos[1] - oldPlayerPosFire[1])]
		elif newPlayerPos[2] == waterChar:
			newBoxPos = [oldBoxPos[0] + (newPlayerPos[0] - oldPlayerPosWater[0]), oldBoxPos[1] + (newPlayerPos[1] - oldPlayerPosWater[1])]
		
		if playerTilemap.get_cell(newBoxPos[0], newBoxPos[1]) == airChar:
			playerTilemap.set_cell(newBoxPos[0], newBoxPos[1], boxChar);
			playerTilemap.set_cell(oldBoxPos[0], oldBoxPos[1], airChar);

			if newPlayerPos.size() != 0 && playerTilemap.get_cell(newPlayerPos[0], newPlayerPos[1]) == airChar:
				playerTilemap.set_cell(newPlayerPos[0], newPlayerPos[1], newPlayerPos[2])

			if newPlayerPos[2] == fireChar:
				playerTilemap.set_cell(oldPlayerPosFire[0], oldPlayerPosFire[1], airChar)
			elif newPlayerPos[2] == waterChar:
				playerTilemap.set_cell(oldPlayerPosWater[0], oldPlayerPosWater[1], airChar)
			else:
				print("ERROR: Couldn't remove old Player")
		output.text = ""
		if(checkWinSituation()):
			output.text = "You won... I think"

func checkWinSituation() -> bool:
	var boxPos = playerTilemap.get_used_cells_by_id(boxChar)
	var boxCount = boxPos.size()
	var pointPosRed = essTilemap.get_used_cells_by_id(finishCharRed)
	var pointPosBlue = essTilemap.get_used_cells_by_id(finishCharBlue)
	var pointPos = pointPosRed + pointPosBlue
	var result = false
	var counter = 0

	for pos in pointPos:
		if boxPos.find(pos) != -1:
			counter += 1
		if counter == boxCount:
			return true
	return false
