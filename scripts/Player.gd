extends Node2D

var tilemap: TileMap
#const waterChar = 0
#const fireChar = 1 

const airChar = -1
const boxChar = 1
const playerChar = 5
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
	var oldPlayerPos = tilemap.get_used_cells_by_id(playerChar)[0]
	var newPlayerPos = []
	
	if Input.is_key_pressed(KEY_W):
		newPlayerPos = [oldPlayerPos[0], oldPlayerPos[1] - 1]
	elif Input.is_key_pressed(KEY_S):
		newPlayerPos = [oldPlayerPos[0], oldPlayerPos[1] + 1]
	elif Input.is_key_pressed(KEY_A):
		newPlayerPos = [oldPlayerPos[0] - 1, oldPlayerPos[1]]
	elif Input.is_key_pressed(KEY_D):
		newPlayerPos = [oldPlayerPos[0] + 1, oldPlayerPos[1]]
	
	if newPlayerPos.size() != 0 && tilemap.get_cell(newPlayerPos[0], newPlayerPos[1]) == airChar:
		tilemap.set_cell(newPlayerPos[0], newPlayerPos[1], playerChar)
		tilemap.set_cell(oldPlayerPos[0], oldPlayerPos[1], airChar)
