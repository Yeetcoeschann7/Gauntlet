extends CharacterBody3D

enum {IDLE, CHASE, CHASE2, CHASE3, SQUELCH, MOVE}
@onready var player_pos = get_tree().root.get_node("RandomLevel/player").global_position
@onready var player = get_tree().root.get_node("RandomLevel/player")
@onready var HUD = get_tree().root.get_node("RandomLevel/player/Camera3D/Hud")
@onready var globs = get_tree().root.get_node("/root/Globs")
@onready var time = get_tree().root.get_node("RandomLevel/floorTime")

const SPEED = 2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var state = IDLE
var dir = 0
var moves_left = 0
var health = 3

func _ready():
	set_scale(Vector3(3,3,3))
	globs.total_slimes += 1

func _physics_process(delta):
	match(health):
		0:
			var tempTime = clamp(time.time_left + 1, 0 , 30)
			time.start(tempTime)
			die()
		_:
			var collision = move_and_collide(velocity * delta)
			if not is_on_floor():
				velocity.y -= gravity * delta
			if(collision):
				if collision.get_collider().name == "player":
					player.take_damage()
					rotation.y += 180
					moves_left = randi_range(50,100)
				if $frontRay.is_colliding() and "GridMap" in $frontRay.get_collider().name:
					rotation.y += delta
					moves_left += 1
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
		$actTimer.wait_time = 0.5
	
	match state:
		IDLE:
			#print("IDLE")
			if ($actTimer.is_stopped()):
				$actTimer.start()
		CHASE:
			#print("CHASE")
			player_pos = get_tree().root.get_node("RandomLevel/player").global_position
			look_at(player_pos)
			self.rotate_object_local(Vector3.UP, PI)
			moves_left = randi_range(50,200)
		CHASE2:
			#print("CHASE")
			player_pos = get_tree().root.get_node("RandomLevel/player").global_position
			look_at(player_pos)
			self.rotate_object_local(Vector3.UP, PI)
			moves_left = randi_range(50,200)
		CHASE3: 
			#print("CHASE")
			player_pos = get_tree().root.get_node("RandomLevel/player").global_position
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
			
func take_damage():
	$hurt.play()
	$slimeAnimation.play("damaged")
	health -= 1
	state = CHASE

func _on_slime_animation_animation_finished(anim_name):
	if(anim_name == "attack"):
		$slimeAnimation.play("squish")
		$actTimer.start()
		$attackCooldown.start()
	if(anim_name == "damaged"):
		$slimeAnimation.play("squish")

func _on_attack_particles_finished():
	queue_free()

func die():
	globs.total_slimes -= 1
	var particles = $attackParticles
	$attackParticles.emitting = true
	$attackParticles/dead.play()
	remove_child(particles)
	particles.position = position
	get_parent().add_child(particles)
	call_deferred("queue_free")
