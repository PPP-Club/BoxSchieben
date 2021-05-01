extends Node2D

var tilemap: TileMap
const waterChar = 0
const fireChar = 5 

const airChar = -1
const boxChar = 1
const finishChar = 2

var charPos = []
var boxPos = []
var finishPos = []

var moveX = 0
var moveY = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	tilemap = $TileMap

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	var oldPlayerPosFire = tilemap.get_used_cells_by_id(fireChar)[0];
	var oldPlayerPosWater = tilemap.get_used_cells_by_id(waterChar)[0];
	var newPlayerPos = []
	
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
	
	if newPlayerPos.size() != 0 && tilemap.get_cell(newPlayerPos[0], newPlayerPos[1]) == airChar:
		tilemap.set_cell(newPlayerPos[0], newPlayerPos[1], newPlayerPos[2])

		if newPlayerPos[2] == fireChar:
			tilemap.set_cell(oldPlayerPosFire[0], oldPlayerPosFire[1], airChar)
		elif newPlayerPos[2] == waterChar:
			tilemap.set_cell(oldPlayerPosWater[0], oldPlayerPosWater[1], airChar)
		else:
			print("ERROR: Couldn't remove old Player")
