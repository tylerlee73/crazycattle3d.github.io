extends CharacterBody3D

const SPEED = 5.0
const FLY_SPEED = 7.5
const JUMP_FORCE = 4.0

var velocity = Vector3.ZERO
var flying = false

func _process(delta):
    if Input.is_action_just_pressed("toggle_fly"):
        flying = !flying
        if flying:
            velocity.y = 0  # stop falling if already midair

func _physics_process(delta):
    var direction = Vector3.ZERO

    if Input.is_action_pressed("move_forward"):
        direction -= transform.basis.z
    if Input.is_action_pressed("move_back"):
        direction += transform.basis.z
    if Input.is_action_pressed("move_left"):
        direction -= transform.basis.x
    if Input.is_action_pressed("move_right"):
        direction += transform.basis.x

    direction = direction.normalized()

    if flying:
        if Input.is_action_pressed("move_up"):
            velocity.y = FLY_SPEED
        elif Input.is_action_pressed("move_down"):
            velocity.y = -FLY_SPEED
        else:
            velocity.y = 0
        velocity.x = direction.x * FLY_SPEED
        velocity.z = direction.z * FLY_SPEED
    else:
        # Regular grounded movement
        velocity.y -= 9.8 * delta  # gravity
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
        if Input.is_action_just_pressed("jump") and is_on_floor():
            velocity.y = JUMP_FORCE

    move_and_slide(velocity, Vector3.UP)
