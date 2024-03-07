# pip install ezdxf
import ezdxf

# Load the DXF document.
doc = ezdxf.readfile("SL-7200-6810800-clamp-hole-surround.dxf")

# Access the modelspace.
modelspace = doc.modelspace()

# Iterate over all entities in the modelspace.
for entity in modelspace:
    # Check if the entity is a type that has a bounding box (not all types do).
    if entity.dxftype() in ['CIRCLE', 'ARC', 'LINE', 'SPLINE']:
        # Get the bounding box of the entity.
        bbox = entity.bounding_box
        if bbox is not None:
            min_point, max_point = bbox
            width = max_point.x - min_point.x
            height = max_point.y - min_point.y
            depth = max_point.z - min_point.z
            print(f"Entity type: {entity.dxftype()}, Width: {width}, Height: {height}, Depth: {depth}")
    elif entity.dxftype() == 'LWPOLYLINE':
        points = entity.get_points()
        min_x = min(p[0] for p in points)
        min_y = min(p[1] for p in points)
        min_z = min(p[2] for p in points)
        max_x = max(p[0] for p in points)
        max_y = max(p[1] for p in points)
        max_z = max(p[2] for p in points)
        width = max_x - min_x
        height = max_y - min_y
        depth = max_z - min_z
        print(f"Entity type: {entity.dxftype()}, Width: {width}, Height: {height}, Depth: {depth}")