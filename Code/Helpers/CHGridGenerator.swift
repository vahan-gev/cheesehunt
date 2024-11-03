//
//  CHGridGenerator'.swift
//  cheesehunt
//
//  Created by Vahan Gevorgyan on 10/30/24.
//

enum BlockType {
    case empty
    case wall
    case cheese
    case obstacle
}

class GridGenerator {
    private let WIDTH = 7
    private let HEIGHT = 10
    
    struct Position: Hashable {
        let x: Int
        let y: Int
    }
    
    private func pathExists(grid: [[BlockType]], from start: Position, to end: Position) -> Bool {
        var queue: [Position] = [start]
        var visited: Set<Position> = []
        
        while !queue.isEmpty {
            let current = queue.removeFirst()
            
            if current == end {
                return true
            }
            
            if visited.contains(current) {
                continue
            }
            
            visited.insert(current)
            
            let directions = [
                Position(x: -1, y: 0), Position(x: 1, y: 0),
                Position(x: 0, y: -1), Position(x: 0, y: 1)
            ]
            
            for direction in directions {
                let newX = current.x + direction.x
                let newY = current.y + direction.y
                
                let newPosition = Position(x: newX, y: newY)
                
                if newX >= 0 && newX < WIDTH &&
                    newY >= 0 && newY < HEIGHT &&
                    grid[newY][newX] != .wall &&
                    grid[newY][newX] != .obstacle {
                    queue.append(newPosition)
                }
            }
        }
        
        return false
    }
    
    private func generateSimpleGrid() -> [[BlockType]] {
        var grid = Array(repeating: Array(repeating: BlockType.empty, count: WIDTH), count: HEIGHT)
        
        grid[1][1] = .cheese
        grid[2][2] = .cheese
        
        grid[1][3] = .obstacle
        grid[3][1] = .obstacle
        
        grid[6][0] = .wall
        grid[0][4] = .wall
        grid[6][4] = .wall
        
        return grid
    }
    
    func generateGrid() -> [[BlockType]] {
        var attempts = 0
        
        while attempts < 100 {
            attempts += 1
            
            var grid = Array(repeating: Array(repeating: BlockType.empty, count: WIDTH), count: HEIGHT)
            
            for y in 0..<HEIGHT {
                for x in 0..<WIDTH {
                    if !(x == 0 && y == 0) && Double.random(in: 0...1) < 0.2 {
                        grid[y][x] = .wall
                    }
                }
            }
            
            let numCheese = Int.random(in: 2...3)
            var cheesePlaced = 0
            var cheesePositions: [Position] = []
            
            var cheeseAttempts = 0
            while cheeseAttempts < 50 && cheesePlaced < numCheese {
                cheeseAttempts += 1
                let x = Int.random(in: 0..<WIDTH)
                let y = Int.random(in: 0..<HEIGHT)
                let position = Position(x: x, y: y)
                
                if grid[y][x] == .empty && !(x == 0 && y == 0) {
                    grid[y][x] = .cheese
                    if pathExists(grid: grid, from: Position(x: 0, y: 0), to: position) {
                        cheesePlaced += 1
                        cheesePositions.append(position)
                    } else {
                        grid[y][x] = .empty
                    }
                }
            }
            
            if cheesePlaced >= 2 {
                let numObstacles = Int.random(in: 2...3)
                var obstaclesPlaced = 0
                
                var obstacleAttempts = 0
                while obstacleAttempts < 50 && obstaclesPlaced < numObstacles {
                    obstacleAttempts += 1
                    let x = Int.random(in: 0..<WIDTH)
                    let y = Int.random(in: 0..<HEIGHT)
                    
                    if grid[y][x] == .empty && !(x == 0 && y == 0) {
                        grid[y][x] = .obstacle
                        var allCheeseReachable = true
                        
                        for cheesePos in cheesePositions {
                            if !pathExists(grid: grid, from: Position(x: 0, y: 0), to: cheesePos) {
                                allCheeseReachable = false
                                break
                            }
                        }
                        
                        if allCheeseReachable {
                            obstaclesPlaced += 1
                        } else {
                            grid[y][x] = .empty
                        }
                    }
                }
                
                var validGrid = true
                for cheesePos in cheesePositions {
                    if !pathExists(grid: grid, from: Position(x: 0, y: 0), to: cheesePos) {
                        validGrid = false
                        break
                    }
                }
                
                if validGrid {
                    return grid
                }
            }
        }
        
        return generateSimpleGrid()
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
                case .wall: symbol = "⬛️"
                case .cheese: symbol = "🧀"
                case .obstacle: symbol = "❌"
                }
                rowString += symbol
            }
            print(rowString)
        }
    }
}
