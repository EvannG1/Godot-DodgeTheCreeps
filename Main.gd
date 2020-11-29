extends Node

export var title = "Dodge the Creeps!"
export var version = "v1.0.0.3"
export (PackedScene) var Mob
var score
var scoreMax = 0

func _process(delta):
	# Ajout du compteur de FPS
	var FPSCounter = str(Engine.get_frames_per_second())
	$HUD/FPSLabel.text = "FPS: " + FPSCounter

func _ready():
	randomize()
	$HUD/VersionLabel.text = version

func new_game():
	score = 0
	$Music.play()
	$Player.start($Player/StartPosition.position)
	$Player/StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Lancement!")

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
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	mob.position = $MobPath/MobSpawnLocation.position
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Définition de la vélocité du mob (vitesse et direction)
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$Player/MobTimer.start()
	$Player/ScoreTimer.start()
