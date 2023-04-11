class Graph {    
    
    var vertices : Set<Tile>    
    var edges :  Set<Edge>

    init(vertices: Set<Tile> = Set<Tile>(), edges: Set<Edge> = Set<Edge>()) {
        self.vertices = vertices
        self.edges = edges        
    }

    func printGraph() {
        let verticesAsString = vertices.map { $0.printTile() }
        let edgesAsString = edges.map { $0.printEdge() }
        print(verticesAsString, edgesAsString)
    }

    func breadthFirstSearch(start: Tile, end: Tile, omit: [Edge] = []) -> [Edge]? {
        let edges = edges.subtracting(omit)
        
        var queue : [Tile] = [start]

        enum Visit {
            case start
            case edge(Edge)
        }
        
        var visits : Dictionary<Tile, Visit> = [start: .start]

        while let currentVertex = queue.popLast() {
            if currentVertex == end {
                var vertex = end
                var route : [Edge] = []

                while let visit = visits[vertex], case .edge(let edge) = visit {
                    route = [edge] + route
                    vertex = edge.from
                }
                return route
            }
            let currentEdges = edges.filter { $0.from == currentVertex }  
            for edge in currentEdges {
                if visits[edge.to] == nil {                    
                    queue.append(edge.to)
                    visits[edge.to] = .edge(edge)
                }
            }
        }
        return nil                
    }
}
