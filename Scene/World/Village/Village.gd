extends Node2D

onready var ground_tilemap: TileMap = $Ground
onready var player: KinematicBody2D = $YSort/Player


func _ready():
	TimeSystem.activate()

	add_child(TileMapSoundComponent.new(
		ground_tilemap,
		GreenBiomGroundTileMapRepresentative.new(),
		player
	))
