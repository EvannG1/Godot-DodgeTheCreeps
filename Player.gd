extends Area2D

signal hit

export var speed = 400 # Vitesse du joueur (pixels/sec)
var screen_size # Taille de la fenêtre du jeu

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2() # Le vecteur de mouvement du joueur
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	# Empêcher le joueur de sortir de l'ecran
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	# Sélection de l'animation selon direction
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	hide() # Disparition du joueur lors de la collision
	emit_signal("hit") # Déclenchement du signal "hit"
	$CollisionShape2D.set_deferred("disabled", true)

# Fonction de réinitialisation du joueur
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
