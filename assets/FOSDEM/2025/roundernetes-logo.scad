// Configuration
logo_thickness = 1;      // From your original file
base_height = 50;        // Height for visibility
base_width = 80;         // Width for stability
base_length = 100;       // Length for stability
support_thickness = 3;   // Support thickness

// Support gusset dimensions
gusset_height = 20;
gusset_length = 20;

// Base plate for stability
module base() {
    translate([-base_width/2, -base_length/3, 0])
        cube([base_width, base_length, support_thickness]);
}

// Triangular support gusset
module gusset() {
    linear_extrude(height = support_thickness)
        polygon(points = [
                [0, 0],
                [0, gusset_height],
                [gusset_length, 0]
            ]);
}

// Vertical support with integrated gussets
module vertical_support() {
    // Main vertical piece
    translate([-support_thickness/2, 0, 0])
        cube([support_thickness, support_thickness, base_height]);

    // Add gussets on both sides
    translate([-support_thickness/2, 0, 0])
        rotate([90, 0, 0])
            gusset();

    translate([support_thickness/2, support_thickness, 0])
        rotate([90, 0, 180])
            gusset();
}

// Complete assembly
union() {
    // Base
    base();

    // Vertical support with gussets
    translate([0, 0, support_thickness])
        vertical_support();

    // Logo with support connection
    translate([0, 0, base_height]) {
        // Angled bracket
        rotate([0, -45, 0])
            translate([-support_thickness/2, 0, 0])
                cube([support_thickness, support_thickness, 20]);

        // Logo itself
        translate([0, 0, 0])
            rotate([0, -45, 0])
                translate([0, 0, 20])  // Offset from bracket
                    linear_extrude(height = logo_thickness) {
                        import("roudnernetes-logo.svg", center=true);
                    }
    }
}
