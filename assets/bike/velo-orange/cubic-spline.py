import numpy as np
from scipy.interpolate import CubicSpline
import matplotlib.pyplot as plt

# c = 31.15; // Longueur de la corde
# h = 11.7; // Hauteur maximale

# Points de contrôle
x = [0, 7.7875, 15.575, 23.3625, 31.15]
y = [0, 11, 11.7, 11, 0]

# Créer la spline cubique
cs = CubicSpline(x, y)

# Générer des points sur la spline
x_new = np.linspace(0, 31.15, 100)
y_new = cs(x_new)

# Exporter les points pour OpenSCAD
points = list(zip(x_new, y_new))
print(points)

# Optionnel : tracer la courbe pour visualisation
plt.plot(x, y, 'o', label='Points de contrôle')
plt.plot(x_new, y_new, label='Spline cubique')
plt.legend(loc='best')
plt.show()

# Convert points to a string in OpenSCAD array format
points_str = "[" + ", ".join(["[%.6f, %.6f]" % (x, y) for x, y in points]) + "]"

# Print the points in OpenSCAD format
print("OpenSCAD Points Array:")
print(points_str)

# Offset value
offset = -1.2


# Function to calculate offset points
def calculate_offset_points(x, y, offset):
    offset_points = []
    for i in range(len(x) - 1):
        # Calculate direction vector of the segment
        dx = x[i + 1] - x[i]
        dy = y[i + 1] - y[i]

        # Calculate the length of the direction vector
        length = np.sqrt(dx ** 2 + dy ** 2)

        # Calculate the normal vector (perpendicular)
        nx = -dy / length
        ny = dx / length

        # Apply the offset to get new points
        new_x = x[i] + nx * offset
        new_y = y[i] + ny * offset

        offset_points.append((new_x, new_y))

    # Handle the last point separately if needed
    # Assuming it follows the direction of the last segment
    new_x = x[-1] + nx * offset
    new_y = y[-1] + ny * offset
    offset_points.append((new_x, new_y))

    return offset_points

# Ensure new_points is defined by generating offset points
new_points = calculate_offset_points(x, y, offset)

# Now, separate x and y values from new_points
new_x_values = [point[0] for point in new_points]
new_y_values = [point[1] for point in new_points]

# Continue with creating the cubic spline and generating new points
cs = CubicSpline(new_x_values, new_y_values)
x_new = np.linspace(0, 31.15, 100)
y_new = cs(x_new)

# Export the points for OpenSCAD
points = list(zip(x_new, y_new))
print(points)

# Convert points to a string in OpenSCAD array format
points_str = "[" + ", ".join(["[%.6f, %.6f]" % (x, y) for x, y in points]) + "]"
print("OpenSCAD Offset Points Array:")
print(points_str)
