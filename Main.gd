extends Node

export var title = "Dodge the Creeps!"
export var version = "v1.0.0.5"
export (PackedScene) var Mob
var score
var scoreMax = 0
var level = 1
var palier = 50
var min_speed = null
var max_speed = null

func _process(delta):
	# Ajout du compteur de FPS
	var FPSCounter = str(Engine.get_frames_per_second())
	$HUD/FPSLabel.text = "FPS: " + FPSCounter

func _ready():
	randomize()
	$HUD/VersionLabel.text = version
	$HUD/LevelLabel.hide()

func new_game():
	score = 0
	# Gestion du volume
	if($HUD.volume < -24):
		$Music.set_volume_db(-80)
		$DeathSound.set_volume_db(-80)
	else:
		$Music.set_volume_db($HUD.volume)
		$DeathSound.set_volume_db($HUD.volume)
	$Music.play()
	$Player.start($Player/StartPosition.position)
	$Player/StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Lancement!")
	$HUD.show_level('[center][wave][rainbow]Niveau ' + str(level) + '[/rainbow][/wave][/center]')

func game_over():
	if(scoreMax < score):
		scoreMax = score
		$HUD.update_score_max("Record: " + str(scoreMax))
	$Player/ScoreTimer.stop()
	$Player/MobTimer.stop()
	$Music.stop()
	$DeathSound.play()
	get_tree().call_group("mobs", "queue_free")
	$HUD.show_game_over()

func _on_MobTimer_timeout():
	# Sélection d'un emplacement aléatoire sur Path2D
	$MobPath/MobSpawnLocation.offset = randi()
	# Création d'une instance "Mob" et l'ajoute à la scène
	var mob = Mob.instance()
	add_child(mob)
	
	# Set du speed
	if(min_speed != null && max_speed != null):
		mob.set_min_speed(min_speed)
		mob.set_max_speed(max_speed)
	
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	mob.position = $MobPath/MobSpawnLocation.position
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Définition de la vélocité du mob (vitesse et direction)
	if(score >= palier):
		level += 1
		$HUD.show_level('[center][wave][rainbow]Niveau ' + str(level) + '[/rainbow][/wave][/center]')
		min_speed = mob.get_min_speed() + 100
		max_speed = mob.get_max_speed() + 100
		mob.set_min_speed(mob.get_min_speed() + 100)
		mob.set_max_speed(mob.get_max_speed() + 100)
		$Player/MobTimer.wait_time -= 0.05
		palier += 50
	
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$Player/MobTimer.start()
	$Player/ScoreTimer.start()
