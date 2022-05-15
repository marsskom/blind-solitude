class_name RemoteTransform2DFactory

static func create(node) -> RemoteTransform2D:
	var remote_transform_2d: RemoteTransform2D = RemoteTransform2D.new()
	remote_transform_2d.set_name(UUID.v4())
	remote_transform_2d.remote_path = node.get_path()

	return remote_transform_2d
