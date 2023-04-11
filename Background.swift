import Scenes
import Igis

  /*
     This class is responsible for rendering the background.
   */


class Background : RenderableEntity {

    var level = Level(size: 8)
    var rects = [[Rect]]()

      init() {
          // Using a meaningful name can be helpful for debugging
          super.init(name:"Background")
      }

      func drawEdge(canvas: Canvas, edge: Edge) {
          let arrow = Path(fillMode: .fillAndStroke)
          let origin : Point
          let destination : Point
          switch edge.direction() {
          case .left:
              origin = Point(x: rects[edge.from.x][edge.from.y].left, y:  rects[edge.from.x][edge.from.y].center.y)
              destination = Point(x: rects[edge.to.x][edge.to.y].right, y: rects[edge.to.x][edge.to.y].center.y)
              arrow.moveTo(origin)
              arrow.lineTo(destination)
              arrow.lineTo(destination + Point(x: 5, y: -3))
              arrow.lineTo(destination + Point(x: 5, y: 3))
          case .right:
              origin = Point(x: rects[edge.from.x][edge.from.y].right, y:  rects[edge.from.x][edge.from.y].center.y)
              destination = Point(x: rects[edge.to.x][edge.to.y].left, y: rects[edge.to.x][edge.to.y].center.y)
              arrow.moveTo(origin)
              arrow.lineTo(destination)
              arrow.lineTo(destination + Point(x: -5, y: -3))
              arrow.lineTo(destination + Point(x: -5, y: 3))
          case .down:
              origin = Point(x: rects[edge.from.x][edge.from.y].center.x, y:  rects[edge.from.x][edge.from.y].bottom)
              destination = Point(x: rects[edge.to.x][edge.to.y].center.x, y: rects[edge.to.x][edge.to.y].top)
              arrow.moveTo(origin)
              arrow.lineTo(destination)
              arrow.lineTo(destination + Point(x: -3, y: -5))
              arrow.lineTo(destination + Point(x: 3, y: -5))
          case .up:
              origin = Point(x: rects[edge.from.x][edge.from.y].center.x, y:  rects[edge.from.x][edge.from.y].top)
              destination = Point(x: rects[edge.to.x][edge.to.y].center.x, y: rects[edge.to.x][edge.to.y].bottom)
              arrow.moveTo(origin)
              arrow.lineTo(destination)
              arrow.lineTo(destination + Point(x: 3, y: 5))
              arrow.lineTo(destination + Point(x: -3, y: 5))
          }
          arrow.lineTo(destination)
          canvas.render(arrow)
      }

      func updateLevel(canvas: Canvas) {
          for x in 0 ..< rects.count {
              for y in 0 ..< rects[x].count {
                  let tile = level.grid[x][y]
                  let rectColor : Color
                      switch tile.state {
                      case .wall:
                          rectColor = Color(.black)
                      case .critical:
                          rectColor = Color(.purple)
                      case .active:
                          rectColor = Color(.yellow)
                      case .empty:
                          rectColor = Color(.gray)
                      }
                      let rectFillStyle = FillStyle(color: rectColor)            
                      let rectangle = Rectangle(rect: rects[x][y], fillMode: .fillAndStroke)
                      canvas.render(rectFillStyle, rectangle)                      
              }
          }
      }

      override func setup(canvasSize: Size, canvas: Canvas) {
          let center = Point(x: canvasSize.width / 2, y: canvasSize.height / 2)
          func initLevel() {    
              level = Level(size:10, inputTiles: [Tile(x:1, y: 1, state: .critical)])    
              
              level.evaluateGrid()
              level.returnTilesOfState(state: .critical).forEach { level.graph.vertices.insert($0) }
              var i = 0
              while i < 8 {
                  level.interruptRandomEdge()
                  i += 1
              }              
              level.testGrid()
              level.emptyToWall()
              level.printGridAsText()
              
              /*
              var paths = [[Edge]]()
              var omitEdges = [Edge]()
              while let path = graph.breadthFirstSearch(start: , end: , omit: omitEdges) {
                  omitEdges += path
                  paths.append(path)
                  
              }
              for path in paths {
                  print("new path:")
                  for edge in path {
                      print(edge.printEdge())
                  }
                  }                 
               */
              

              for x in 0 ..< level.grid.count {
                  var rectColumns = [Rect]()
                  for y in 0 ..< level.grid[x].count {                      
                      let rect = Rect(topLeft: Point(x: x * 30, y: y * 30), size: Size(width: 30, height: 30))
                      rectColumns.append(rect)                      
                  }
                  rects.append(rectColumns)
              }              

              updateLevel(canvas: canvas)
              level.graph.edges.forEach { drawEdge(canvas: canvas, edge: $0) }
              
          }

          initLevel()
          
      }

/*      override func render(canvas:Canvas) {

      } */
      
}
