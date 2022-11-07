extends RigidBody2D

func launch(force: Vector2):
	print("should launch: " % str(force))
	apply_impulse(Vector2.ZERO, force)
