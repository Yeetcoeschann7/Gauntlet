extends CharacterBody3D

const SPEED = 1000
const JUMP_VELOCITY = 4.5
@onready var BULLET = preload("res://assets/scenes/player/arrow.tscn")
@onready var HUD = get_tree().root.get_node("mainLevel/player/Camera3D/Hud")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var health = 3

func _physics_process(delta):
	# Add the gravity.
		
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
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * delta
		velocity.z = direction.z * SPEED * delta
		$Armature.rotation.y = Input.get_vector("ui_up", "ui_down", "ui_left", "ui_right").angle()
		$AnimationPlayerLegs.play("Walk_Legs")
		if (not Input.is_action_pressed("shoot")):
			$AnimationPlayerTop.play("Walk_Arms")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		$AnimationPlayerLegs.play("Stand_Legs")
		if ($AnimationPlayerTop.current_animation != "Shoot"):
			$AnimationPlayerTop.play("Stand_Arms")
	if Input.is_action_just_pressed("shoot"):
		$AnimationPlayerTop.play("Shoot")
		if $shootTimer.is_stopped():
			$shootTimer.start()

	move_and_slide()

func take_damage():
	if $iframes.is_stopped():
		health -= 1
		if health <= 0:
			HUD.game_over()
		HUD.get_node("healthBar").value -= 1
		print("CURRENT HEALTH: ", health)
		$iframes.start()

func _on_shoot_timer_timeout():
	var bullet = BULLET.instantiate()
	get_tree().root.get_node("mainLevel").add_child(bullet)
	bullet.global_transform = $Armature/Skeleton3D/Cube/firePoint.global_transform
	bullet.set_scale(Vector3(0.2,0.2,0.2))
