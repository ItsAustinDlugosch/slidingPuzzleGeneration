class Level {
    var grid: [[Tile]]
    var graph = Graph()
    let size: Int

    init(size: Int, inputTiles: [Tile] = []) {
        self.size = size
        var columns = [[Tile]]()
        
        for x in 1 ... size {
            var columnTiles = [Tile]()
            for y in 1 ... size {
                columnTiles.append(Tile(x: x, y: y))
            }
            // add border to columns
            columnTiles.insert(Tile(x: x, y: 0, state: .wall), at: 0)
            columnTiles.append(Tile(x: x, y: size + 1, state: .wall))
            columns.append(columnTiles)
        }
        var borderColumns = [[Tile]]()
        for x in [0, size + 1] {            
            var borderColumnTiles = [Tile]()
            for y  in 0 ... size + 1 {
                borderColumnTiles.append(Tile(x: x, y: y, state: .wall))    
            }
            borderColumns.append(borderColumnTiles)
        }
        columns.insert(borderColumns[0], at: 0)
        columns.append(borderColumns[1])

        for tile in inputTiles {
            columns[tile.x][tile.y] = tile
            
        }
        grid = columns
    }

    func printGrid() {
        for x in 0 ..< grid.count {
            for y in 0 ..< grid[x].count {
                print("Tile(x: \(grid[x][y].x), y: \(grid[x][y].y), state: \(grid[x][y].state)")            
            }
        }
    }

    func printTileState(state: Tile.TileState) {
        for x in 0 ..< grid.count {
            for y in 0 ..< grid[x].count {
                if grid[x][y].state == state {
                    print("Tile(x: \(grid[x][y].x), y: \(grid[x][y].y), state: \(grid[x][y].state)")
                }
            }
        }
    }

    func returnColumn(tile: Tile) -> [Tile] {
        var column = [Tile]()
        for y in 0 ..< size {
            column.append(Tile(x: tile.x, y: y))
        }
        return column
    }

    func returnRow(tile: Tile) -> [Tile] {
        var row = [Tile]()
        for x in 0 ..< size {
            row.append(Tile(x: x, y: tile.y))
        }
        return row
    }

    func returnTilesOfState(state: Tile.TileState) -> [Tile] {
        var tiles = [Tile]()
        for x in 0 ..< grid.count {
            for y in 0 ..< grid[x].count {
                if grid[x][y].state == state {
                    tiles.append(grid[x][y])
                }
            }
        }
        return tiles
    }

    func slideToWall(tile: Tile, direction: Direction) -> Tile {
        var i = 1
        switch direction {
        case .up:
            if tile.y > 1 {               
                while grid[tile.x][tile.y - i].state != .wall {
                    if grid[tile.x][tile.y - i].state == .empty {
                        grid[tile.x][tile.y - i].state = .active
                    }
                    i += 1                    
                }
                return Tile(x: tile.x, y: tile.y - i + 1, state: .critical)
            }
        case .down:
            if tile.y < size {
                while grid[tile.x][tile.y + i].state != .wall {
                    if grid[tile.x][tile.y + i].state == .empty {
                        grid[tile.x][tile.y + i].state = .active
                    }
                    i += 1
                }
                return Tile(x: tile.x, y: tile.y + i - 1, state: .critical)
            }
        case .left:
            if tile.x > 1 {
                while grid[tile.x - i][tile.y].state != .wall {
                    if grid[tile.x - i][tile.y].state == .empty {
                        grid[tile.x - i][tile.y].state = .active
                    }
                    i += 1
                }
                return Tile(x: tile.x - i + 1, y: tile.y, state: .critical)
            }
        case .right:
            if tile.x < size {
                while grid[tile.x + i][tile.y].state != .wall {
                    if grid[tile.x + i][tile.y].state == .empty {
                        grid[tile.x + i][tile.y].state = .active
                    }
                    i += 1
                }
                return Tile(x: tile.x + i - 1, y: tile.y, state: .critical)
            }
        }
        return tile
    }

    func evaluateCriticalTiles(criticalTile: Tile) -> [Tile] {
        var newCriticalTiles = [Tile]()
        
        let upTile = slideToWall(tile: criticalTile, direction: .up)
        let downTile = slideToWall(tile: criticalTile, direction: .down)
        let leftTile = slideToWall(tile: criticalTile, direction: .left)
        let rightTile = slideToWall(tile: criticalTile, direction: .right)

        let checkTiles = [upTile, downTile, leftTile, rightTile]
        for tile in checkTiles {
            if criticalTile != tile {
                graph.edges.insert(Edge(from: criticalTile, to: tile))
            }
            
            if grid[tile.x][tile.y].state != .critical {
                grid[tile.x][tile.y].state = .critical                            
                newCriticalTiles.append(tile)
            } 
        }

        return newCriticalTiles
    }

    func evaluateActiveTiles(criticalTile: Tile) {
        let row = returnRow(tile: criticalTile)
        for tile in row {
            if grid[tile.x][tile.y].state == .empty {
                grid[tile.x][tile.y].state = .active
            }
        }

        let column = returnColumn(tile: criticalTile)
        for tile in column {
            if grid[tile.x][tile.y].state == .empty {
                grid[tile.x][tile.y].state = .active
            }
        }            
    }

    func resetCriticals() {
        let criticalTiles = returnTilesOfState(state: .critical)
        for index in 1 ..< criticalTiles.count {
            grid[criticalTiles[index].x][criticalTiles[index].y].state = .empty
        }

        let activeTiles = returnTilesOfState(state: .active)
        for index in 0 ..< activeTiles.count {
            grid[activeTiles[index].x][activeTiles[index].y].state = .empty
        }

        evaluateGrid()
    }
    
    func evaluateGrid() {
        let criticalTiles = returnTilesOfState(state: .critical)
        
        for criticalTile in criticalTiles {
            let newCriticalTiles = evaluateCriticalTiles(criticalTile: criticalTile)
            if newCriticalTiles.count > 0 {
                evaluateGrid()
            }

            evaluateActiveTiles(criticalTile: criticalTile)
        }
    }

    
    func interruptRandomEdge() {
        var edge: Edge
        repeat {
            edge = graph.edges.randomElement()!
        } while edge.length() < 5

        graph.edges.remove(edge)
        
        let wallTile = edge.tileOfRadius(radius: Int.random(in: 3 ... edge.length() / 2 + 1))
        grid[wallTile.x][wallTile.y].state = .wall
        evaluateGrid()
    }

    
    func testGrid() {
        resetCriticals()
        graph.edges = []
        graph.vertices = []
        grid[1][1].state = .critical
        evaluateGrid()
        let activeTiles = returnTilesOfState(state: .active)
        activeTiles.forEach {$0.state = .empty}
        let criticalTiles = returnTilesOfState(state: .critical)

        criticalTiles.forEach {
            for direction in [Direction]([.up, .down, .left, .right]) {
                slideToWall(tile: $0, direction: direction)
            }
        }        
    }

    func emptyToWall() {
        let emptyTiles = returnTilesOfState(state: .empty)
        emptyTiles.forEach { grid[$0.x][$0.y].state = .wall }
    }

    func printGridAsText() {
        var characterGrid = [[Character]]()
        for x in 0 ..< grid.count {
            var characterColumn = [Character]()
            for y in 0 ..< grid[x].count {
                switch grid[y][x].state { // read by row not column
                case .wall:
                    characterColumn.append("x")
                default:
                    characterColumn.append(".")
                }
            }
            characterGrid.append(characterColumn)
        }
        characterGrid.forEach { print($0) }
    }    
}
