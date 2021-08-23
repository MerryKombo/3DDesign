points = [[0,0,0], [77,0,0], [14,45.50,0], [63,45.5,0]];

trapezium(points);
echo(trapezoid(points));
echo(rectangle(points));

module trapezium(points) {
    // the base 1 is point 0 to point 1
    // the base 2 is point 2 to point 3
    bigBase = points[1][0] - points[0][0];
    littleBase = points[3][0] - points[2][0];
    height = points[3][1] - points[0][1];
    area = (bigBase*littleBase*height)/2;
    echo("Big base is : ", bigBase, ", small base is : ", littleBase, ", height is : ", height, ", area is : ", area);
}

module rectangle(points) {
    trapezium(points);
}

function trapezoid(points) = ((points[1][0] - points[0][0])*(points[3][0] - points[2][0])*(points[3][1] - points[0][1]))/2;

function rectangle(points) = trapezoid(points);