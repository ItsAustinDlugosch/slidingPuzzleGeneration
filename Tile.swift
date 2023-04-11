class Tile {

    let x : Int
    let y : Int

    enum TileState {
        case empty, active, critical, wall
    }

    var state : TileState

    init(x: Int, y: Int, state: TileState = .empty) {
        self.x = x
        self.y = y
        self.state = state
    }

    func printTile() -> String {
        return "Tile(x: \(x), y: \(y), state: \(state))"
    }


}

extension Tile: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension Tile: Equatable {
    public static func ==(lhs: Tile, rhs: Tile) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}
