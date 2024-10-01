extends CharacterBody3D

@export var SPEED: int = 1000
const JUMP_VELOCITY = 4.5
@onready var BULLET = preload("res://assets/scenes/player/arrow.tscn")
@onready var HUD = get_tree().root.get_child(2).get_node("player/Camera3D/Hud")
@onready var globs = get_tree().root.get_node("/root/Globs")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var health = globs.player_health
var roundsLeft = 0
var look_rot = 0
var controllers = Input.get_connected_joypads()

func _physics_process(delta):
	controllers = Input.get_connected_joypads()
	health = globs.player_health
	if health <= 0:
		HUD.game_over()
		
	if $iframes.time_left > 0:
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
		if $Armature/Skeleton3D/Cube.get_active_material(0).albedo_color == Color(1,1,1,1):
			$Armature/Skeleton3D/Cube.get_active_material(0).albedo_color = Color(1,1,0.4,1)
		else:
			$Armature/Skeleton3D/Cube.get_active_material(0).albedo_color = Color(1,1,1,1)
	else:
		set_collision_layer_value(1, true)
		set_collision_mask_value(1, true)
		$Armature/Skeleton3D/Cube.get_active_material(0).albedo_color = Color(1,1,0.4,1)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var look_dir = Input.get_vector("shoot_left", "shoot_right", "shoot_up", "shoot_down")
	var look_direction = (transform.basis * Vector3(look_dir.x, 0, look_dir.y)).normalized()
	if look_direction:
		$Armature.rotation.y = Input.get_vector("shoot_up", "shoot_down", "shoot_left", "shoot_right").angle()
		look_rot = $Armature.rotation.y
	else:
		$Armature.rotation.y = look_rot
	if direction:
		velocity.x = direction.x * SPEED * delta
		velocity.z = direction.z * SPEED * delta
		$AnimationPlayerLegs.play("Walk_Legs")
		if (not Input.is_action_pressed("shoot")):
			$AnimationPlayerTop.play("Walk_Arms")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		$AnimationPlayerLegs.play("Stand_Legs")
		if ($AnimationPlayerTop.current_animation != "Shoot"):
			$AnimationPlayerTop.play("Stand_Arms")
	if (Input.is_action_pressed("shoot") or look_direction) and roundsLeft <= 0 and $volleyTimer.time_left <= 0:
		roundsLeft = 5
		$volleyTimer.start()
	if roundsLeft > 0:
		$AnimationPlayerTop.play("Shoot")
		if $shootTimer.is_stopped():
			if roundsLeft > 0:
				$shootTimer.start()
				roundsLeft -= 1

	move_and_slide()

func take_damage():
	if $iframes.is_stopped():
		globs.player_health -= 30
		print("CURRENT HEALTH: ", health)
		$iframes.start()
		
func heal():
	if globs.player_health <= 85:
		globs.player_health += 15
	else:
		globs.player_health = 90
	print("CURRENT HEALTH: ", health)

func _on_shoot_timer_timeout():
	var bullet = BULLET.instantiate()
	get_tree().root.get_child(0).add_child(bullet)
	bullet.global_transform = $Armature/Skeleton3D/Cube/firePoint.global_transform
	bullet.set_scale(Vector3(0.2,0.2,0.2))
