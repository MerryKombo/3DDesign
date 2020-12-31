include <../utils/areas.scad>

function getAllPoints(topBoard, bottomBoard) = concat(topBoard, bottomBoard);

// points is a Vector of two points [[1,3,5],[4,6,9]]
function getDistance(points) = sqrt(pow(points[0].x - points[1].x, 2) + pow(points[0].y - points[1].
y, 2) + pow(points[0].z - points[1].z, 2));

// origin is the point we want to calculate the distance to, points is all the points we want the distance of respectively to origin
function getAllDistances(origin, points, indices) = [for (a = [0 : 1 : len(points) - 1]) [getDistance([origin,points[a]]), indices[a]]];

function getAllDistancesSorted(origin, points, indices) = quicksort_col(getAllDistances(origin, points, indices), 0);

function select(vector, indices) = [ for (index = indices) vector[index] ];

function range2vector(r) = [ for (i=r) i];

function keepPoints(distancesToKeep, points) = [for (a = [0 : 1 : len(distancesToKeep) - 1]) [points[distancesToKeep[a].y]]];

//function calculateDistance
module getNearestPoints(points, numberOfNearestPoints = 2) {
    for (idx = [0 : len(points) - 1]) {
        if (idx == 0) {
            echo(points);
            selector = range2vector([1:len(points)-1]);
            echo(selector);
            selectVector = select(points, selector);
            echo("Select Vector", selectVector);
            echo("Points are: ", [points[0], points[1]]);
            echo("Distance from ", points[0], "to", points[1], " is ", getDistance([points[0], points[1]]));
            sortedDistances = getAllDistancesSorted(points[0], selectVector, selector);
            isIn = search(points[idx], sortedDistances);
            echo("Found ", isIn, " as the ", points[idx] , " (current point) in the resulting list");
            mostNearestPointsSelector = range2vector([0:numberOfNearestPoints-1]);
            // il faut enlever le point qui a les mêmes coordonnées, sous peine de se retrouver avec un lien de longueur 0
            // il faudra travailler sur le range, ajouter 1 à droite et à gauche, donc on passe par exemple de 0-1 à 1-2
            distancesToKeep = select(sortedDistances, mostNearestPointsSelector);
            echo("Point distances: ", sortedDistances, ", we'll only keep ", distancesToKeep);
            pointsKept = keepPoints(distancesToKeep, points);
            echo("We kept the points", pointsKept);
        } else if (idx == len(points)-1) {
            selector = range2vector([0:len(points)-2]);
            selectVector = select(points, selector);
            sortedDistances = getAllDistancesSorted(points[idx], selectVector, selector);
            echo("Last point ", sortedDistances);
            isIn = search(points[idx], sortedDistances);
            echo("Found ", isIn, " as the ", points[idx] , " (current point) in the resulting list");
            mostNearestPointsSelector = range2vector([0:numberOfNearestPoints-1]);
            // il faut enlever le point qui a les mêmes coordonnées, sous peine de se retrouver avec un lien de longueur 0
            // il faudra travailler sur le range, ajouter 1 à droite et à gauche, donc on passe par exemple de 0-1 à 1-2
            distancesToKeep = select(sortedDistances, mostNearestPointsSelector);
            echo("Point distances: ", sortedDistances, ", we'll only keep ", distancesToKeep);
            pointsKept = keepPoints(distancesToKeep, points);
            echo("We kept the points", pointsKept);
        } else {
            selector = concat(range2vector([0:idx - 1]),range2vector([idx + 1:len(points) - 1]));
            selectVector = select(points, selector);
            sortedDistances = getAllDistancesSorted(points[idx], selectVector, selector);
            echo("Point #", idx, sortedDistances);
            isIn = search(points[idx], sortedDistances);
            echo("Found ", isIn, " as the ", points[idx] , " (current point) in the resulting list");
            mostNearestPointsSelector = range2vector([0:numberOfNearestPoints-1]);
            // il faut enlever le point qui a les mêmes coordonnées, sous peine de se retrouver avec un lien de longueur 0
            // il faudra travailler sur le range, ajouter 1 à droite et à gauche, donc on passe par exemple de 0-1 à 1-2
            distancesToKeep = select(sortedDistances, mostNearestPointsSelector);
            echo("Point distances: ", sortedDistances, ", we'll only keep ", distancesToKeep);
            pointsKept = keepPoints(distancesToKeep, points);
            echo("We kept the points", pointsKept);
        }
    }
}


// type is an int
// 0 is positionned at zero
// 1 is positionned at bottomBoard 2nd point
// 2 is positionned at 0X, Y of bottomBoard 3rd point
// 3 is positionned at bottomBoard 4th point
// 4 is centered (tricky)
// moving is a [x, y] vector which indicates how we should translate the board once we have applied the positionning decided by type
// topBoard is the list of coordinates for the top board
// bottomBoard is the list of coordinates for the bottom board
module positionTopBoard(type, moving, topBoard, bottomBoard) {
    toReturn = topBoard;
    if (type == 0) {
        // do nothing
    } else if (type == 1) {
        // positionned at bottomBoard 2nd point
        bottomBoard2ndPoint = bottomBoard[1];
        topBoard2ndPoint = topBoard[1];
        xDistanceToAdd = bottomBoard2ndPoint[0] - topBoard2ndPoint[0];
        echo("Top Board is ", topBoard);
        toReturn = move(topBoard, [xDistanceToAdd, 0]);
        echo("The type I board now is ", toReturn);
    } else if (type == 2) {
        // positionned at 0X, Y of bottomBoard 3rd point
        bottomBoard3rdPoint = bottomBoard[2];
        topBoard3rdPoint = topBoard[2];
        yDistanceToAdd = bottomBoard3rdPoint[1] - topBoard3rdPoint[1];
        echo("Top Board is ", topBoard);
        toReturn = move(topBoard, [0, yDistanceToAdd]);
        echo("The type II board now is ", toReturn);
    } else if (type == 3) {
        // positionned at bottomBoard 4th point
        bottomBoard4thPoint = bottomBoard[3];
        topBoard4thPoint = topBoard[3];
        yDistanceToAdd = bottomBoard4thPoint[1] - topBoard4thPoint[1];
        xDistanceToAdd = bottomBoard4thPoint[0] - topBoard4thPoint[0];
        echo("Top Board is ", topBoard);
        toReturn = move(topBoard, [xDistanceToAdd, yDistanceToAdd]);
        echo("The type III board now is ", toReturn);

    } else {
        bottomBoardMax = [maximum(getX(bottomBoard)), maximum(getY(bottomBoard))];
        topBoardMax = [maximum(getX(topBoard)), maximum(getY(topBoard))];
        XandYToAddToCenter = (bottomBoardMax - topBoardMax) / 2;
        echo("To center, will have to move by ", XandYToAddToCenter);
        toReturn = move(topBoard, XandYToAddToCenter);
        echo("The moved board now is ", toReturn);
    }
    if (moving != [0, 0]) {
        echo("Top Board is ", topBoard);
        toReturn = move(topBoard, moving);
        echo("The moved board now is ", toReturn);
    }
    echo("The moved board now is ", toReturn);
}

// type is an int
// 0 is positionned at zero
// 1 is positionned at bottomBoard 2nd point
// 2 is positionned at 0X, Y of bottomBoard 3rd point
// 3 is positionned at bottomBoard 4th point
// 4 is centered (tricky)
// moving is a [x, y] vector which indicates how we should translate the board once we have applied the positionning decided by type
// topBoard is the list of coordinates for the top board
// bottomBoard is the list of coordinates for the bottom board
function positionTopBoard(type, moving, topBoard, bottomBoard) =
(
    type == 0?
    move(topBoard, moving)
    : type == 1?
    // positionned at bottomBoard 2nd point
    let
        (
        bottomBoard2ndPoint = bottomBoard[1],
        topBoard2ndPoint = topBoard[1],
        xDistanceToAdd = bottomBoard2ndPoint[0] - topBoard2ndPoint[0]
    )
    move(move(topBoard, [xDistanceToAdd, 0]), moving)
    : type == 2?
            // positionned at 0X, Y of bottomBoard 3rd point
            let
                (
                bottomBoard3rdPoint = bottomBoard[2],
                topBoard3rdPoint = topBoard[2],
                yDistanceToAdd = bottomBoard3rdPoint[1] - topBoard3rdPoint[1]
            )
            move(move(topBoard, [0, yDistanceToAdd]), moving)
            : type == 3?
                    // positionned at bottomBoard 4th point
                    let
                        (
                        bottomBoard4thPoint = bottomBoard[3],
                        topBoard4thPoint = topBoard[3],
                        yDistanceToAdd = bottomBoard4thPoint[1] - topBoard4thPoint[1],
                        xDistanceToAdd = bottomBoard4thPoint[0] - topBoard4thPoint[0]
                    )
                    move(move(topBoard, [xDistanceToAdd, yDistanceToAdd]), moving)
                    :
                        let
                            (
                            bottomBoardMax = [maximum(getX(bottomBoard)), maximum(getY(bottomBoard))
                                ],
                            topBoardMax = [maximum(getX(topBoard)), maximum(getY(topBoard))],
                            XandYToAddToCenter = (bottomBoardMax - topBoardMax) / 2
                        )
                        move(move(topBoard, XandYToAddToCenter), moving)
);

// Returns the X of a vector
function getX(vector) = [for (a = [0 : 1 : len(vector) - 1]) vector[a].x];

// Returns the Y of a vector
function getY(vector) = [for (a = [0 : 1 : len(vector) - 1]) vector[a].y];

// board is the board we want to translate
// moving is the [x,y] lengths we want to translate the board to
function move(board, moving) = let(
    movedBoard = [for (a = [0 : 1 : len(board) - 1]) [board[a][0] + moving[0], board[a][1] + moving[
    1], board[a][2]]]
)
movedBoard;

// boards is a vector of vector of points
module getTheBiggest(boards) {
    echo("I'm in getTheBiggest");
    areas = [for (a = [0 : 1 : len(boards) - 1]) [trapezoid(boards[a]), a]];
    result = quicksort_col(areas, 0);
    echo("Will return ", result[len(result) - 1][1]);
    echo("Leaving getTheBiggest. ", result, ". Drive safe.");
}

// boards is a vector of vector of points
function getTheBiggest(boards) = let(
    areas = [for (a = [0 : 1 : len(boards) - 1]) [trapezoid(boards[a]), a]],
    result = quicksort_col(areas, 0),
    index = result[len(result) - 1][1]
)
index;

function maximum(a, i = 0) = (i < len(a) - 1) ? max(a[i], maximum(a, i + 1)) : a[i];

// Found there: https://openscadsnippetpad.blogspot.com/2017/05/quick-sort.html
function quicksort_col(list, col = 0) =
    !(len(list) > 0)?[]:
        let(
            pivot = list[floor(len(list) / 2)][col],
            list_lesser = [for (i = [0:len(list) - 1])if ( list[i][col] < pivot )list[i]],
            list_equal = [for (i = [0:len(list) - 1])if ( list[i][col] == pivot )list[i]],
            list_greater = [for (i = [0:len(list) - 1])if ( list[i][col] > pivot )list[i]])

        concat(

        quicksort_col(list_lesser),

        list_equal,

        quicksort_col(list_greater));