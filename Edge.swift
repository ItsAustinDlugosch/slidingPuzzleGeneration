class Edge {
    let from: Tile
    let to: Tile

    init(from: Tile, to: Tile) {       
        self.from = from
        self.to = to
    }

    func printEdge() -> String{
        return "\(from.printTile()) -> \(to.printTile())"
    }

    func direction() -> Direction {
        if from.x > to.x {
            return .left
        } else if from.x < to.x {
            return .right
        } else if from.y < to.y {
            return .down
        } else {
            return .up
        }
    }

    func length() -> Int {
        switch direction() {
        case .left:
            return from.x - to.x + 1
        case .right:
            return to.x - from.x + 1
        case .down:
            return to.y - from.y + 1
        case .up:
            return from.y - to.y + 1
        }
    }

    func tileOfRadius(radius: Int) -> Tile {
        precondition(radius < length(), "Radius must be less than the length of the edge.")
        switch direction() {
        case .left:
            return Tile(x: from.x - radius, y: from.y)
        case .right:
            return Tile(x: from.x + radius, y: from.y)
        case .up:
            return Tile(x: from.x, y: from.y - radius)
        case .down:
            return Tile(x: from.x, y: from.y + radius)
        }
    }
}

extension Edge: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension Edge: Equatable {
    public static func ==(lhs: Edge, rhs: Edge) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}
