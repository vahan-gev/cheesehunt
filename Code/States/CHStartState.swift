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
    
    let menuNode = SKNode()
    let generator = GridGenerator()
    let buttonNode = SKSpriteNode(imageNamed: "play")
    let mundurik = SKSpriteNode(imageNamed: "mundurik")
    
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
    
    override func willExit(to nextState: GKState) {
        menuNode.removeAllActions()
        menuNode.run(SKAction.fadeOut(withDuration: 1.0)) {
            self.menuNode.removeAllChildren()
            self.menuNode.removeFromParent()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: scene!)
        
        if buttonNode.contains(touchLocation) {
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
        buttonNode.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)
        buttonNode.size = CGSize(width: 100, height: 100)
        buttonNode.zPosition = 1
        menuNode.addChild(buttonNode)

        mundurik.size = CGSize(width: 365, height: 332.56)
        mundurik.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.minY + 50)
        menuNode.addChild(mundurik)
        scene?.addChild(menuNode)
    }
}

// MARK: Helpers
extension CHStartState {
    func handleTap(_ touches: Set<UITouch>) {
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

