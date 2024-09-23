extends CharacterBody3D

enum {IDLE, CHASE, SQUELCH, MOVE}
@onready var player_pos = get_tree().root.get_node("mainLevel/player").global_position
@onready var player = get_tree().root.get_node("mainLevel/player")
@onready var HUD = get_tree().root.get_node("mainLevel/player/Camera3D/Hud")
@onready var TRAIL = preload("res://assets/scenes/enemies/slimeDecal.tscn")
@onready var globs = get_tree().root.get_node("/root/Globs")

const SPEED = 2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var state = IDLE
var dir = 0
var moves_left = 0
var health = 5

func _ready():
	set_scale(Vector3(5,5,5))

func _physics_process(delta):
	if health <= 0:
		globs.total_slimes -= 1
		var i = str_to_var(HUD.get_node("Score/scoreValue").text) + 100
		HUD.get_node("Score/scoreValue").text = var_to_str(i)
		var particles = $attackParticles
		$attackParticles.emitting = true
		$attackParticles/dead.play()
		remove_child(particles)
		particles.position = position
		get_parent().add_child(particles)
		call_deferred("queue_free")
	var collision = move_and_collide(velocity * delta)
	if not is_on_floor():
		velocity.y -= gravity * delta
	if(collision):
		if collision.get_collider().name == "player":
			player.take_damage()
			rotation.y += 180
			moves_left = randi_range(50,100)
		if $frontRay.is_colliding():
			if $frontRay.get_collider().name == "GridMap":
				rotation.y += delta
				moves_left += delta
	if(moves_left > 0 and $slimeAnimation.current_animation != "damaged"):
		var angle = self.get_rotation().y
		position += (Vector3(sin(angle),0, cos(angle)) * 10 ) * (delta * SPEED)
		moves_left -= 1
	else:
		if ($actTimer.is_stopped()):
			$actTimer.start()
			
	move_and_slide()


func _on_act_timer_timeout():
	state = randi_range(IDLE,MOVE)
	if abs(global_position - player_pos) < Vector3(20,0,20):
		state = CHASE
		$actTimer.wait_time = 0.5
	
	match state:
		IDLE:
			#print("IDLE")
			if ($actTimer.is_stopped()):
				$actTimer.start()
		CHASE:
			#print("CHASE")
			player_pos = get_tree().root.get_node("mainLevel/player").global_position
			look_at(player_pos)
			self.rotate_object_local(Vector3.UP, PI)
			moves_left = randi_range(50,200)
		SQUELCH:
			#print("SQUELCH")
			$squelch.pitch_scale = randf_range(0.8,3)
			$squelch.play()
			if ($actTimer.is_stopped()):
				$actTimer.start()
		MOVE:
			#print("MOVE")
			dir = randi_range(0,7) * 45
			rotation.y = dir
			moves_left = randi_range(50,200)
		_:
			print("PASS")
			pass
			
func take_damage():
	$hurt.play()
	$slimeAnimation.play("damaged")
	health -= 1
	pass

func _on_slime_animation_animation_finished(anim_name):
	if(anim_name == "attack"):
		$slimeAnimation.play("squish")
		$actTimer.start()
		$attackCooldown.start()
	if(anim_name == "damaged"):
		$slimeAnimation.play("squish")

func _on_attack_particles_finished():
	queue_free()
