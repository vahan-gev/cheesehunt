//
//  CHStartState.swift
//  cheesehunt
//
//  Created by Vahan Gevorgyan on 10/27/24.
//

import GameplayKit
import SpriteKit


class CHGameState: GKState {
    unowned let gameScene: CHGameScene
    
    init(gameScene: CHGameScene) {
        self.gameScene = gameScene
        super.init()
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {   }
}

class CHStartState: CHGameState {
    weak var scene: CHGameScene?
    weak var context: CHGameContext?
    private var coolDownDuration: TimeInterval = 0.7
    
    let testNode = SKNode()
    let testLabel = SKLabelNode(text: "TEST")
    let generator = GridGenerator()
    let buttonNode = SKSpriteNode(imageNamed: "play")
    
    init(scene: CHGameScene, context: CHGameContext) {
        self.scene = scene
        self.context = context
        super.init(gameScene: scene)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func didEnter(from previousState: GKState?) {
        print("did enter StartState")
        
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: scene!)
        
        if buttonNode.contains(touchLocation) {
            // Button was tapped
            let grid = generator.generateGrid()
            generator.printGrid(grid)
            print("===================")
        } else {
            handleTap(touches)
        }
    }
}

// MARK: Setup
extension CHStartState {
    func setupUI() {
        let fontSize: CGFloat = 118
        
        testLabel.fontSize = fontSize
        testLabel.fontName = "SF-Pro-Rounded"
        testLabel.alpha = 0.0
        testLabel.position = CGPoint(x: 0, y: 0)
        
        testNode.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)
        testNode.zPosition = -1
        testNode.alpha = 1.0
        
        testNode.addChild(testLabel)
        scene?.addChild(testNode)
        
        buttonNode.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY - 200) // Position below label
        buttonNode.size = CGSize(width: 100, height: 100) // Set appropriate size for button
        buttonNode.zPosition = 1 // Ensure it's on top
        scene?.addChild(buttonNode)
    }
}

// MARK: Helpers
extension CHStartState {
    func handleTap(_ touches: Set<UITouch>) {
        animateLabel(testLabel)
        print("tapping")
        gameScene.incrementScore()
    }
    
    func animateLabel(_ label: SKLabelNode) {
        let fadeIn = SKAction.fadeIn(withDuration: coolDownDuration * 2/3)
        let fadeOut = SKAction.fadeOut(withDuration: coolDownDuration * 1/3)
        let sequence = SKAction.sequence([fadeIn, fadeOut])
        label.run(sequence)
    }
}

