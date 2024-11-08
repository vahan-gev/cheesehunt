    //
    //  CHGameState.swift
    //  cheesehunt
    //
    //  Created by Vahan Gevorgyan on 11/3/24.
    //

    import GameplayKit
    import SpriteKit

    class CHGameState: CHGeneralState {
        var layoutInfo = CHLayoutInfo()
        let generator = GridGenerator()
        let containerNode = SKNode()
        let gridNode = SKNode()
        let livesNode = SKNode()
        private var grid: [[BlockType]] = []
        private var tileNodes: [[SKSpriteNode]] = []
        
        private var isGridRevealed = false
        private var countdownLabel: SKLabelNode!
        
        private var revealedTiles: [[Bool]] = []
        
        init(scene: CHGameScene, context: CHGameContext) {
            super.init(gameScene: scene, context: context)
        }
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
            return true
        }
        
        override func didEnter(from previousState: GKState?) {
            print("did enter GameState")
            setupUI()
            grid = generator.generateGrid()
            context.gameInfo.reset()
            gameScene.updateScore()
            renderGrid()
            showGrid()
        }
        
        override func willExit(to nextState: GKState) {
            resetUI()
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if isGridRevealed { return }
            guard let touch = touches.first else { return }
            let touchLocation = touch.location(in: gridNode)
            let gridX = Int((touchLocation.x + (CGFloat(generator.WIDTH) * layoutInfo.effectiveTileSize / 2)) / layoutInfo.effectiveTileSize)
            let gridY = Int((CGFloat(generator.HEIGHT) * layoutInfo.effectiveTileSize / 2 - touchLocation.y) / layoutInfo.effectiveTileSize)
            
            if gridX >= 0 && gridX < generator.WIDTH && gridY >= 0 && gridY < generator.HEIGHT {
                //print("Tapped tile at: (\(gridX), \(gridY)) - Type: \(grid[gridY][gridX])")
                if revealedTiles[gridY][gridX] { return }
                revealedTiles[gridY][gridX] = true
                revealTileTexture(at: gridX, y: gridY)
                if grid[gridY][gridX] == .cheese {
                    generator.cheeseCount -= 1
                    //playLightHaptic()
                    if generator.cheeseCount == 0 {
                        gameScene.incrementScore()
                        gridNode.removeAllChildren()
                        gridNode.removeAllActions()
                        grid = generator.generateGrid()
                        generator.printGrid(grid)
                        renderGrid()
                        showGrid()
                    }
                } else if grid[gridY][gridX] == .poop || grid[gridY][gridX] == .obstacle {
                    context.gameInfo.decrementLives(by: 1)
                    updateLivesDisplay()
                    //playHeavyHaptic()
                    if context.gameInfo.lives <= 0{
                        gameScene.context.stateMachine?.enter(CHEndState.self)
                    }
                }
            }
        }
    }

    // MARK: Setup
    extension CHGameState {
        func setupUI() {
            self.containerNode.run(SKAction.fadeIn(withDuration: 0.2))

            let gridWidth = CGFloat(generator.WIDTH) * layoutInfo.effectiveTileSize
            let gridHeight = CGFloat(generator.HEIGHT) * layoutInfo.effectiveTileSize
            
            containerNode.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)
            
            gridNode.position = .zero
            livesNode.position = .zero
            
            setupLives(gridWidth: gridWidth, gridHeight: gridHeight, effectiveTileSize: layoutInfo.effectiveTileSize)
            containerNode.addChild(gridNode)
            containerNode.addChild(livesNode)
            gameScene.addChild(containerNode)
        }
        
        func resetUI() {
            self.containerNode.removeAllActions()
            self.containerNode.run(SKAction.fadeOut(withDuration: 0.1)) {
                self.containerNode.removeAllChildren()
                self.containerNode.removeFromParent()
                self.gridNode.removeAllChildren()
                self.gridNode.removeFromParent()
                self.livesNode.removeAllChildren()
                self.livesNode.removeFromParent()
                self.revealedTiles = []
                self.isGridRevealed = false
                self.tileNodes = []
            }
        }
        
        func setupLives(gridWidth: CGFloat, gridHeight: CGFloat, effectiveTileSize: CGFloat) {
            let startX = -gridWidth / 2
            let startY = gridHeight / 2
            
            for i in 0..<context.gameInfo.lives {
                let x = startX + layoutInfo.effectiveTileSize / 2 + (layoutInfo.effectiveTileSize * 0.7 * 1.1 * CGFloat(i))
                let y = startY + layoutInfo.effectiveTileSize / 2
                let cheeseNode = createCheeseNode(
                    x: x,
                    y: y,
                    width: layoutInfo.effectiveTileSize * 0.7,
                    height: layoutInfo.effectiveTileSize * 0.7
                )
                livesNode.addChild(cheeseNode)
            }
        }
        
        private func updateLivesDisplay() {
            livesNode.removeAllChildren()
            
            let gridWidth = CGFloat(generator.WIDTH) * layoutInfo.effectiveTileSize
            let gridHeight = CGFloat(generator.HEIGHT) * layoutInfo.effectiveTileSize
            let startX = -gridWidth / 2
            let startY = gridHeight / 2
             for i in 0..<context.gameInfo.lives {
                 let x = startX + layoutInfo.effectiveTileSize / 2 + (layoutInfo.effectiveTileSize * 0.7 * 1.1 * CGFloat(i))
                 let y = startY + layoutInfo.effectiveTileSize / 2
                let cheeseNode = createCheeseNode(
                    x: x,
                    y: y,
                    width: layoutInfo.effectiveTileSize * 0.7,
                    height: layoutInfo.effectiveTileSize * 0.7
                )
                livesNode.addChild(cheeseNode)
            }
        }
        
        func renderGrid() {
            tileNodes = Array(repeating: Array(repeating: SKSpriteNode(), count: generator.WIDTH), count: generator.HEIGHT)
            revealedTiles = Array(repeating: Array(repeating: false, count: generator.WIDTH), count: generator.HEIGHT)
            let gridWidth = CGFloat(generator.WIDTH) * layoutInfo.effectiveTileSize
            let gridHeight = CGFloat(generator.HEIGHT) * layoutInfo.effectiveTileSize
            
            let startX = -gridWidth / 2
            let startY = gridHeight / 2
            
            for (y, row) in grid.enumerated() {
                for (x, type) in row.enumerated() {
                    let tile = createTile(for: type)
                    tile.position = CGPoint(
                        x: startX + (CGFloat(x) * layoutInfo.effectiveTileSize) + layoutInfo.tileSize/2,
                        y: startY - (CGFloat(y) * layoutInfo.effectiveTileSize) - layoutInfo.tileSize/2
                    )
                    tileNodes[y][x] = tile
                    gridNode.addChild(tile)
                }
            }
        }
        
        private func createTile(for type: BlockType) -> SKSpriteNode {
            let texture = getDefaultNameForTexture(type)
            let tile = SKSpriteNode(imageNamed: texture)
            tile.size = CGSize(width: layoutInfo.tileSize, height: layoutInfo.tileSize)
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
        
        private func revealTileTexture(at x: Int, y: Int) {
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


// MARK: Grid Helpers
extension CHGameState {
    func showGrid() {
        isGridRevealed = true
        for (y, row) in grid.enumerated() {
            for (x, type) in row.enumerated() {
                let tile = tileNodes[y][x]
                tile.texture = SKTexture(imageNamed: getTextureNameForType(type))
            }
        }
        
        countdownLabel = SKLabelNode(fontNamed: "Futura-Medium")
        countdownLabel.fontSize = 65
        countdownLabel.fontColor = .black
        countdownLabel.position = CGPoint(x: 0, y: 0)
        countdownLabel.zPosition = 10
        countdownLabel.horizontalAlignmentMode = .center
        countdownLabel.verticalAlignmentMode = .center
        containerNode.addChild(countdownLabel)
        
        var timeLeft = 4
        countdownLabel.text = "\(timeLeft)"
        
        let wait = SKAction.wait(forDuration: 1.0)
        let countdown = SKAction.run { [weak self] in
            timeLeft -= 1
            self?.countdownLabel.text = "\(timeLeft)"
        }
        
        let sequence = SKAction.sequence([
            SKAction.repeat(SKAction.sequence([countdown, wait]), count: 3),
            SKAction.run { [weak self] in
                self?.hideGrid()
            }
        ])
        
        containerNode.run(sequence)
    }

    func hideGrid() {
        countdownLabel.removeFromParent()
        
        for (_, row) in tileNodes.enumerated() {
            for (_, tile) in row.enumerated() {
                let fadeOut = SKAction.fadeOut(withDuration: 0.1)
                let changeTexture = SKAction.run { [weak self] in
                    tile.texture = SKTexture(imageNamed: self?.getDefaultNameForTexture(.empty) ?? "question_tile")
                }
                let fadeIn = SKAction.fadeIn(withDuration: 0.1)
                
                let sequence = SKAction.sequence([fadeOut, changeTexture, fadeIn])
                tile.run(sequence)
            }
        }
        isGridRevealed = false
    }
}


// MARK: Vibration Helpers
extension CHGameState {
    private func playLightHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    private func playHeavyHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}
