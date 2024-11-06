    //
    //  CHGameState.swift
    //  cheesehunt
    //
    //  Created by Vahan Gevorgyan on 11/3/24.
    //

    import GameplayKit
    import SpriteKit

    class CHGameState: CHGeneralState {
        let generator = GridGenerator()
        let containerNode = SKNode()
        let gridNode = SKNode()
        let livesNode = SKNode()
        private var grid: [[BlockType]] = []
        private let tileSize: CGFloat = 50
        private let padding: CGFloat = 2
        private var tileNodes: [[SKSpriteNode]] = []
        
        init(scene: CHGameScene, context: CHGameContext) {
            super.init(gameScene: scene, context: context)
        }
        
        override func didEnter(from previousState: GKState?) {
            print("did enter GameState")
            setupUI()
            grid = generator.generateGrid()
            generator.printGrid(grid)
            renderGrid()
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let touchLocation = touch.location(in: gridNode)
            
            let effectiveTileSize = tileSize + padding
            let gridX = Int((touchLocation.x + (CGFloat(generator.WIDTH) * effectiveTileSize / 2)) / effectiveTileSize)
            let gridY = Int((CGFloat(generator.HEIGHT) * effectiveTileSize / 2 - touchLocation.y) / effectiveTileSize)
            
            if gridX >= 0 && gridX < generator.WIDTH && gridY >= 0 && gridY < generator.HEIGHT {
                print("Tapped tile at: (\(gridX), \(gridY)) - Type: \(grid[gridY][gridX])")
                updateTileTexture(at: gridX, y: gridY)
                if grid[gridY][gridX] == .cheese {
                    gameScene.incrementScore()
                } else if grid[gridY][gridX] == .poop || grid[gridY][gridX] == .obstacle {
                    context.gameInfo.decrementLives(by: 1)
                    updateLivesDisplay()
                }
            }
        }
    }

    // MARK: Setup
    extension CHGameState {
        func setupUI() {
            let effectiveTileSize = tileSize + padding
            let gridWidth = CGFloat(generator.WIDTH) * effectiveTileSize
            let gridHeight = CGFloat(generator.HEIGHT) * effectiveTileSize
            
            containerNode.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)
            
            gridNode.position = .zero
            livesNode.position = .zero
            
            setupLives(gridWidth: gridWidth, gridHeight: gridHeight, effectiveTileSize: effectiveTileSize)
            gameScene.addChild(containerNode)
        }
        
        func setupLives(gridWidth: CGFloat, gridHeight: CGFloat, effectiveTileSize: CGFloat) {
            let startX = -gridWidth / 2
            let startY = gridHeight / 2
            
            for i in 0..<context.gameInfo.lives {
                let x = startX + effectiveTileSize/2 + (effectiveTileSize * 1.1 * CGFloat(i))
                let y = startY + effectiveTileSize
                let cheeseNode = createCheeseNode(
                    x: x,
                    y: y,
                    width: effectiveTileSize,
                    height: effectiveTileSize
                )
                livesNode.addChild(cheeseNode)
            }
            containerNode.addChild(livesNode)
        }
        
        private func updateLivesDisplay() {
            livesNode.removeAllChildren()
            
            let effectiveTileSize = tileSize + padding
            let gridWidth = CGFloat(generator.WIDTH) * effectiveTileSize
            let gridHeight = CGFloat(generator.HEIGHT) * effectiveTileSize
            let startX = -gridWidth / 2
            let startY = gridHeight / 2
             for i in 0..<context.gameInfo.lives {
                let x = startX + effectiveTileSize/2 + (effectiveTileSize * 1.1 * CGFloat(i))
                let y = startY + effectiveTileSize
                let cheeseNode = createCheeseNode(
                    x: x,
                    y: y,
                    width: effectiveTileSize,
                    height: effectiveTileSize
                )
                livesNode.addChild(cheeseNode)
            }
        }
        
        func renderGrid() {
            tileNodes = Array(repeating: Array(repeating: SKSpriteNode(), count: generator.WIDTH), count: generator.HEIGHT)
            
            let effectiveTileSize = tileSize + padding
            let gridWidth = CGFloat(generator.WIDTH) * effectiveTileSize
            let gridHeight = CGFloat(generator.HEIGHT) * effectiveTileSize
            
            let startX = -gridWidth / 2
            let startY = gridHeight / 2
            
            for (y, row) in grid.enumerated() {
                for (x, type) in row.enumerated() {
                    let tile = createTile(for: type)
                    tile.position = CGPoint(
                        x: startX + (CGFloat(x) * effectiveTileSize) + tileSize/2,
                        y: startY - (CGFloat(y) * effectiveTileSize) - tileSize/2
                    )
                    tileNodes[y][x] = tile
                    gridNode.addChild(tile)
                }
            }
            containerNode.addChild(gridNode)
        }
        
        private func createTile(for type: BlockType) -> SKSpriteNode {
            let texture = getDefaultNameForTexture(type)
            let tile = SKSpriteNode(imageNamed: texture)
            tile.size = CGSize(width: tileSize, height: tileSize)
            return tile
        }
        
        private func createCheeseNode(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> SKSpriteNode {
            let cheese = SKSpriteNode(imageNamed: "cheese")
            cheese.position = CGPoint(x: x, y: y)
            cheese.size = CGSize(width: width, height: height)
            cheese.zPosition = 2
            return cheese
        }
        
        private func getTextureNameForType(_ type: BlockType) -> String {
            switch type {
            case .empty:
                return "empty_tile"
            case .poop:
                return "poop_tile"
            case .cheese:
                return "cheese_tile"
            case .obstacle:
                return "obstacle_tile"
            }
        }
        
        private func getDefaultNameForTexture(_ type: BlockType) -> String {
            switch type {
            case .empty:
                return "question_tile"
            case .poop:
                return "question_tile"
            case .cheese:
                return "question_tile"
            case .obstacle:
                return "question_tile"
            }
        }
        
        private func updateTileTexture(at x: Int, y: Int) {
            let tile = tileNodes[y][x]
            let currentType = grid[y][x]
            
            grid[y][x] = currentType
            
            let fadeOut = SKAction.fadeOut(withDuration: 0.1)
            let changeTexture = SKAction.run { [weak self] in
                let newTextureName = self?.getTextureNameForType(currentType) ?? "empty_tile"
                tile.texture = SKTexture(imageNamed: newTextureName)
            }
            let fadeIn = SKAction.fadeIn(withDuration: 0.1)
            
            let sequence = SKAction.sequence([fadeOut, changeTexture, fadeIn])
            tile.run(sequence)
        }
    }
