class Vertex {
    var criticalTile : Tile
    
    init(criticalTile: Tile) {
        self.criticalTile = criticalTile
    }

    func printVertex() -> String {
        return "\(criticalTile.printTile())"
    }
}

extension Vertex: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension Vertex: Equatable {
    public static func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}
