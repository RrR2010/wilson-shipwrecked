"""Executable Blender probe: every bounds corner stays inside the review camera."""
from pathlib import Path
import sys

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import bpy
from mathutils import Vector
from bpy_extras.object_utils import world_to_camera_view
from _workflow_common import bounds_corners, camera_direction, make_view_camera


def main():
    scene = bpy.context.scene
    for width, height in [(960, 720), (1280, 720), (720, 960), (720, 720)]:
        scene.render.resolution_x = width
        scene.render.resolution_y = height
        for size in [(0.5, 0.5, 0.48), (1.5, 0.4, 0.5), (1.7, 0.8, 1.45)]:
            bounds = {'min': [-size[0]/2, -size[1]/2, 0],
                      'max': [size[0]/2, size[1]/2, size[2]],
                      'center': [0, 0, size[2]/2], 'radius': Vector(size).length/2}
            for direction in [camera_direction(45, 35), Vector((0, 1, 0)), Vector((1, 0, 0)), Vector((0, 0, 1))]:
                camera = make_view_camera(scene=scene, name='__framing_probe', bounds=bounds,
                                          direction=direction, aspect=width/height, margin=1.18)
                bpy.context.view_layer.update()
                for point in bounds_corners(bounds):
                    projected = world_to_camera_view(scene, camera, point)
                    assert .07 < projected.x < .93 and .07 < projected.y < .93, (width, height, size, projected)
                data = camera.data
                bpy.data.objects.remove(camera, do_unlink=True)
                bpy.data.cameras.remove(data)
    print('PASS: review framing covers 48 aspect/shape/view combinations')


if __name__ == '__main__':
    main()
