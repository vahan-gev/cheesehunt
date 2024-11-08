enum BlockType {
    case empty
    case poop
    case cheese
    case obstacle
}

class GridGenerator {
    let WIDTH = 5
    let HEIGHT = 7
    var cheeseCount = 0
    var poopCount = 0
    var obstacleCount = 0
    
    func generateGrid() -> [[BlockType]] {
        var grid = Array(repeating: Array(repeating: BlockType.empty, count: WIDTH), count: HEIGHT)
        cheeseCount = 0
        poopCount = 0
        obstacleCount = 0
        let minimumRequired = 2
        
        while cheeseCount < minimumRequired {
            let x = Int.random(in: 0..<WIDTH)
            let y = Int.random(in: 0..<HEIGHT)
            if !(x == 0 && y == 0) && grid[y][x] == .empty {
                grid[y][x] = .cheese
                cheeseCount += 1
            }
        }
        
        while poopCount < minimumRequired {
            let x = Int.random(in: 0..<WIDTH)
            let y = Int.random(in: 0..<HEIGHT)
            if !(x == 0 && y == 0) && grid[y][x] == .empty {
                grid[y][x] = .poop
                poopCount += 1
            }
        }
        
        while obstacleCount < minimumRequired {
            let x = Int.random(in: 0..<WIDTH)
            let y = Int.random(in: 0..<HEIGHT)
            if !(x == 0 && y == 0) && grid[y][x] == .empty {
                grid[y][x] = .obstacle
                obstacleCount += 1
            }
        }
        
        for y in 0..<HEIGHT {
            for x in 0..<WIDTH {
                if grid[y][x] == .empty && !(x == 0 && y == 0) {
                    let random = Double.random(in: 0...1)
                    switch random {
                    case 0..<0.1:
                        grid[y][x] = .cheese
                        cheeseCount += 1
                    case 0.1..<0.2:
                        grid[y][x] = .poop
                        poopCount += 1
                    case 0.2..<0.3:
                        grid[y][x] = .obstacle
                        obstacleCount += 1
                    default:
                        grid[y][x] = .empty
                    }
                }
            }
        }
        
        return grid
    }
    
    func reset() {
        cheeseCount = 0
        poopCount = 0
        obstacleCount = 0
    }
}

extension GridGenerator {
    func printGrid(_ grid: [[BlockType]]) {
        for row in grid {
            var rowString = ""
            for cell in row {
                let symbol: String
                switch cell {
                case .empty: symbol = "⬜️"
                case .poop: symbol = "💩"
                case .cheese: symbol = "🧀"
                case .obstacle: symbol = "❌"
                }
                rowString += symbol
            }
            print(rowString)
        }
        print("Cheese: \(cheeseCount), Poop: \(poopCount), Obstacles: \(obstacleCount)")
    }
}
